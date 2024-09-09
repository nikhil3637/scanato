import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:scanato/server/apis.dart';
import 'package:http/http.dart' as http;

import '../common_widgets/background_widget.dart';
import '../constants/global_variable.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool showResult = false;
  Barcode? scannedBarcode;
  final uniqueId = Get.arguments;
  ApiServices apiServices = ApiServices();
  double? balance;
  int? amount;
  int? CenterId;
  String? MachineCode;
  String? TimeToOn;
  String? PlanName;
  String? CenterName;
  String? MachineName;
  bool paymentSuccessful = false;
  late CameraController _cameraController;
  late BarcodeScanner _barcodeScanner;
  late List<dynamic> rate = [];
  List<dynamic>? offer;
  bool isScanning = false;
  bool isFlashOn = false;


  Future<void> fetchBalance() async {
    try {
      final balanceData = await apiServices.fetchBalanceData(uniqueId);
      setState(() {
        balance = balanceData;
        print('balance==============%$balance');
      });
    } catch (e) {
      print('Error fetching balance: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBalance();
    initializeCamera();
    _barcodeScanner = BarcodeScanner();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController.initialize();
    // await _cameraController.setZoomLevel(zoomValue);
    await _cameraController.setFlashMode(FlashMode.off);

    setState(() {});
    startBarcodeScanning();
  }

  Future<void> startBarcodeScanning() async {
    if (isScanning) return;
    isScanning = true;

    _cameraController.startImageStream((image) async {
      if (!mounted) return;

      try {
        final image = await _cameraController.takePicture();
        final inputImage = InputImage.fromFilePath(image.path);
        final barcodes = await _barcodeScanner.processImage(inputImage);

        if (barcodes.isNotEmpty) {
          final barcode = barcodes.first;

          if (scannedBarcode == null) {
            setState(() {
              scannedBarcode = barcode;
            });

            await getPaymentDetails(scannedBarcode?.displayValue, uniqueId);

            _cameraController.stopImageStream();
            isScanning = false;
          }

          return;
        }
      } catch (e) {
        print('Error during barcode scanning: $e');
      }
    });
  }

  void toggleFlashlight() async {
    try {
      if (isFlashOn) {
        await _cameraController.setFlashMode(FlashMode.off);
      } else {
        await _cameraController.setFlashMode(FlashMode.torch);
      }
      setState(() {
        isFlashOn = !isFlashOn;
      });
    } catch (e) {
      print('Error toggling flashlight: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          title: Image.asset(
            'assets/images/robologo.jpg',
            height: 100,
            width: 100,
          ),
          actions: [
            IconButton(
              icon: Icon(
                isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: isFlashOn ? Colors.yellow : Colors.grey,
              ),
              onPressed: toggleFlashlight,
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: showResult
                    ? _buildPaymentDetails() // Show payment details
                    : CameraPreview(_cameraController), // Show camera preview
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildPaymentDetails() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying Center and Machine Name as Cards
            Text(
              'Balance: ${balance ?? 'N/A'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
            _buildCard("Center Name:", CenterName ?? "N/A"),
            _buildCard("Machine Name:", MachineName ?? "N/A"),
            SizedBox(height: 20),

            // Display Table with Amount, Package Name, Time to On, and Radio buttons
            _buildRateTable(),

            SizedBox(height: 30,),
            // Display the amount to pay
            Text('Amount to Pay: ${calculateAmountToPay()}',
              style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),),
            SizedBox(height: 20),
            Center(
              child: paymentSuccessful
                  ? ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Back',
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : ElevatedButton(
                onPressed: amount != null ? handlePayment : null,
                child: const Text(
                  'Pay',
                  style: TextStyle(fontSize: 18),
                ),
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue),
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.white),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(6.0),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Method to create a table with Amount, Package Name, Time to On, Offer, and Radio buttons
  Widget _buildRateTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey, width: 1),
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1), // For Offer column
        4: FixedColumnWidth(50), // For radio button column
      },
      children: [
        // Table Header
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[200]),
          children: [
            _buildTableCell('Plan Name', isHeader: true),
            _buildTableCell('Time to On', isHeader: true),
            _buildTableCell('Amount', isHeader: true),
            _buildTableCell('Offer', isHeader: true), // New Offer Header
            _buildTableCell('', isHeader: true), // Empty header for radio button
          ],
        ),
        // Table Rows for each rate item with Offer and Radio button
        ...rate.asMap().entries.map((entry) {
          int index = entry.key;
          dynamic item = entry.value;
          return TableRow(
            children: [
              _buildTableCell(item["planName"] ?? 'N/A'),
              _buildTableCell(item["timeToOn"].toString()),
              _buildTableCell(item["rate"].toString()),
              _buildTableCell(
                item["offer"] != null && item["offer"].isNotEmpty
                    ? "Discount: ${item["offer"]["discount"]}"
                    : "No Offer",
              ), // Display offer details or default text
              _buildRadioButtonCell(index, item),
            ],
          );
        }).toList(),
      ],
    );
  }


// Helper method to create table cells with optional header styling
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 14 : 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

// Helper method to create a radio button cell
  Widget _buildRadioButtonCell(int index, dynamic item) {
    return Radio(
      value: item["rate"],
      groupValue: amount,
      onChanged: (value) {
        setState(() {
          amount = value; // Update amount based on selected package
          TimeToOn = rate[index]['timeToOn'].toString(); // Update TimeToOn based on selected package
          PlanName = rate[index]['planName'].toString();
        });
      },
    );
  }

// Payment handler method
  Future<void> handlePayment() async {
    if (amount == null) return; // Ensure an amount is selected
    amount = calculateAmountToPay();
    if (balance != null && amount != null) {
      if (amount! > 0 && balance! >= amount!) {
        try {
          bool success = await apiServices.PayByUser(
            amount.toString(),
            uniqueId.toString(),
            MachineCode.toString(),
            CenterId.toString(),
            TimeToOn.toString(),
            PlanName.toString()
          );
          if (success) {
            setState(() {
              fetchBalance();
              paymentSuccessful = true;
            });
          }
        } catch (error) {
          Get.snackbar(
            'Payment Error',
            'An error occurred during the payment process.',
          );
        }
      } else {
        Get.snackbar(
          'Insufficient Balance',
          amount! <= 0
              ? 'Amount must be greater than zero for payment.'
              : 'Your balance is not sufficient for this payment.',
        );
      }
    } else {
      print('Balance or amount is null.');
    }
  }


  Widget _buildCard(String title, String content) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              content,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }




  // Method to calculate the final amount to pay
  calculateAmountToPay() {
    if (amount != null && offer != null && offer!.isNotEmpty) {
      num finalAmount = amount! - offer?[0]["discount"];
      return finalAmount.toInt();
    } else if (amount != null) {
      return amount;
    } else {
      return "N/A";
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> getPaymentDetails(machineId, uniqueId) async {

    try {
      final response = await http.post(
          Uri.parse('${GlobalVariable.baseUrl}/Center/GetMachinePlan'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            'userId': uniqueId,
            'machinecode': machineId.toString(),
          },
          ));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response data of payment===========+#$responseData');
        final centerName = responseData['data']['center']['name'];
        final centerId = responseData['data']['center']['id'];
        final machineName = responseData['data']['machine']['name'];
        final machineCode = responseData['data']['machine']['machineCode'];
        final rateValue = responseData['data']['rate'];
        final offers = responseData['data']['offer'];


        setState(() {
          rate = rateValue;
          offer = offers;
          CenterName = centerName;
          MachineName = machineName;
          CenterId = centerId;
          MachineCode = machineCode;
          showResult = true;
        });
      } else {
        print('Registration failed with status code ${response.statusCode}');
      }
    } catch (error) {
      print('Registration failed with error: $error');
    }
  }
}