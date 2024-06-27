  import 'dart:convert';
  import 'dart:io';
  import 'package:camera/camera.dart';
  import 'package:flutter/foundation.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:qr_code_scanner/qr_code_scanner.dart';
  import 'package:scanato/server/apis.dart';
  import 'package:http/http.dart' as http;

  import '../constants/global_variable.dart';

  class Payment extends StatefulWidget {
    const Payment({Key? key}) : super(key: key);

    @override
    State<Payment> createState() => _PaymentState();
  }

  class _PaymentState extends State<Payment> {
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    Barcode? result;
    QRViewController? controller;
    bool showResult = false;
    TextEditingController amountController = TextEditingController();
    final uniqueId = Get.arguments;
    ApiServices apiServices = ApiServices();
    double? balance;
    int? amount;
    int? CenterId;
    String? MachineCode;
    String? TimeToOn;
    String? CenterName;
    String? MachineName;
    bool paymentSuccessful = false;
    late CameraController _cameraController;
    late QRViewController _qrController;
    double zoomValue = 10.0;
    late List<dynamic> rate = [];
    List<dynamic>? offer;



    @override
    void reassemble() {
      super.reassemble();
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      } else if (Platform.isIOS) {
        controller!.resumeCamera();
      }
    }

    // Future<void> initializeCamera() async {
    //   final cameras = await availableCameras();
    //   final camera = cameras.first;
    //
    //   _cameraController = CameraController(
    //     camera,
    //     ResolutionPreset.high,
    //   );
    //
    //   _cameraController.initialize().then((_) {
    //     if (!mounted) {
    //       return;
    //     }
    //     setState(() {});
    //
    //     // Zoom controls
    //     _cameraController.setZoomLevel(zoomValue);
    //     _cameraController.addListener(() {
    //     });
    //   });
    // }


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
      // initializeCamera();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
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
                    : QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.green,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 6,
                    cutOutSize: 300,
                  ),
                ),
              ),
            ],
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
              Text('Balance: ${balance}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.black),textAlign: TextAlign.left,),
              _buildCard("Center Name:", CenterName ?? "N/A"),
              _buildCard("Machine Name:", MachineName ?? "N/A"),
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text('Select Payment ', style: TextStyle(fontSize: 18)),
                  Container(
                    height:  rate.length * 70.0 , // Adjust the height dynamically
                    child: Column(
                      children: List.generate(rate.length, (index) {
                        return RadioListTile(
                          title: Text('Amount: ${rate[index]["rate"]}'),
                          value: rate[index]["rate"],
                          groupValue: amount,
                          onChanged: (value) {
                            setState(() {
                              amount = value;
                              TimeToOn = rate[index]['timeToOn'].toString();
                            });
                          },
                        );
                      }),
                    ),
                  ),
                  ],
                ),
              ),_buildCard("Time to On:", TimeToOn ?? "N/A"),
              _buildCard("Offer:", offer != null && offer!.isNotEmpty ? "Discount: ${offer?[0]["discount"]}" : "No Offer Available"),

              // Display the amount to pay
              Text('Amount to Pay: ${calculateAmountToPay()}'),
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
                  onPressed: () async {
                     amount = calculateAmountToPay();
                    if (balance != null && amount != null) {
                      if (amount! > 0 && balance! >= amount!) {
                        bool success = await apiServices.PayByUser(amount.toString(), uniqueId.toString(), MachineCode.toString(), CenterId.toString(), TimeToOn.toString());
                        if (success) {
                          setState(() {
                            fetchBalance();
                            paymentSuccessful = true;
                          });
                        }
                      } else {
                        if (amount! <= 0) {
                          Get.snackbar(
                            'Invalid Amount',
                            'Amount must be greater than zero for payment.',
                          );
                        } else {
                          Get.snackbar(
                            'Insufficient Balance',
                            'Your balance is not sufficient for this payment.',
                          );
                        }
                      }
                    } else {
                      print('Balance or amount is null.');
                    }
                  },
                  child: const Text(
                    'Pay',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
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

    Future<void> _onQRViewCreated(QRViewController controller) async {
      _qrController = controller;

      _qrController.scannedDataStream.listen((scanData) {
        setState(() {
          result = scanData;
          showResult = true;
          _qrController.pauseCamera();
          getPaymentDetails(result!.code, uniqueId);
        });
      });

      if (_cameraController.value.isInitialized) {
        await _cameraController.setFlashMode(FlashMode.torch); // or FlashMode.auto for automatic flash
        _cameraController.setZoomLevel(zoomValue);
        _cameraController.addListener(() {
        });
      }

      await _qrController.flipCamera(); // Flip the camera for better autofocus

      await Future.delayed(const Duration(milliseconds: 400));

      await _qrController.flipCamera(); // Flip the camera back to its original state
    }


    @override
    void dispose() {
      _qrController.dispose();
      _cameraController.dispose();
      controller?.dispose();
      super.dispose();
    }

    Future<void> getPaymentDetails(machineId, uniqueId) async {
      print('Register uniqueId========$uniqueId');
      print('payment reslult cpde========$machineId');

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

          });
        } else {
          print('Registration failed with status code ${response.statusCode}');
        }
      } catch (error) {
        print('Registration failed with error: $error');
      }
    }
  }