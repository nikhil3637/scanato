import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
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
  int? MachineId;
  String? CenterName;
  String? MachineName;
  bool paymentSuccessful = false; // Add this variable

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
        title: Text('QR Code Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: showResult
                  ? Container()
                  : QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            if (showResult)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.greenAccent.shade200,
                    shadowColor: Colors.greenAccent,
                    elevation: 6,
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Balance: ${balance}'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Center Name: ${CenterName ?? "N/A"}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Machine Name: ${MachineName ?? "N/A"}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Amount: ${amount ?? 0}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: paymentSuccessful
                        ? ElevatedButton(
                      onPressed: () {
                        // Navigate back to the previous screen
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
                          if (balance! >= amount!) {
                            // Allow the user to pay
                            bool success = await apiServices.PayByUser(
                                amount, uniqueId, MachineId, CenterId);
                            if (success) {
                              setState(() {
                                fetchBalance();
                                paymentSuccessful = true; // Payment successful
                              });
                            }
                          } else {
                            Get.snackbar(
                              'Insufficient Balance',
                              'Your balance is not sufficient for this payment.',
                            );
                          }
                        } else {
                          // Handle the case where balance or amount is null.
                          print('Balance or amount is null.');
                        }
                      },
                      child: const Text(
                        'Pay',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
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
          'machinecode': machineId,
        }),
      );

      if (response.statusCode == 200) {
        // Parsing the JSON response
        final responseData = jsonDecode(response.body);
        final centerName = responseData['data']['center']['name'];
        final centerId = responseData['data']['center']['id'];
        final machineName = responseData['data']['machine']['name'];
        final machineId = responseData['data']['machine']['id'];
        final rateValue = responseData['data']['rate']['rate'];

        setState(() {
          amount = rateValue;
          CenterName = centerName;
          MachineName = machineName;
          CenterId = centerId;
          MachineId = machineId;
        });
        print('Center Name: $centerName');
        print('Machine Name: $machineName');
        print('Rate: $rateValue');

        // You can use these values as needed in your application

        // Show a success dialog using GetX
        Get.defaultDialog(
          title: 'Success',
          middleText:
          'Center Name: $centerName\nMachine Name: $machineName\nRate: $rateValue\nMachineId: $MachineId\ncenterId: $CenterId',
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        );
      } else {
        // Handle errors or non-200 status codes here
        print('Registration failed with status code ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions here
      print('Registration failed with error: $error');
    }
  }
}
