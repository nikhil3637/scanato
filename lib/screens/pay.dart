import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scanato/server/apis.dart';
import 'package:http/http.dart' as http;

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
  String? CenterName;
  String? MachineName;
  bool paymentSuccessful = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

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
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      alignment: Alignment.center,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Balance: ${balance}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.black),textAlign: TextAlign.left,),
          SizedBox(height: 20),
          _buildCard("Center Name:", CenterName ?? "N/A"),
          _buildCard("Machine Name:", MachineName ?? "N/A"),
          _buildCard("Amount:", "${amount ?? 0}"),
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
                  if (balance != null && amount != null) {
                    if (amount! > 0 && balance! >= amount!) {
                      bool success = await apiServices.PayByUser(amount, uniqueId, MachineCode, CenterId);
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
                    EdgeInsets.all(16.0),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              )


          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String content) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
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


  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        showResult = true;
        controller.pauseCamera();
        getPaymentDetails(result!.code, uniqueId);
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> getPaymentDetails(machineId, uniqueId) async {
    print('Register uniqueId========$uniqueId');

    try {
      final response = await http.post(
          Uri.parse('http://124.123.76.123:88/api/Center/GetMachinePlan'),
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
        final centerName = responseData['data']['center']['name'];
        final centerId = responseData['data']['center']['id'];
        final machineName = responseData['data']['machine']['name'];
        final machineCode = responseData['data']['machine']['machineCode'];
        final rateValue = responseData['data']['rate']['rate'];

        setState(() {
          amount = rateValue;
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