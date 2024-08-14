import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_scankit/flutter_scankit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scanato/server/apis.dart';

import '../constants/global_variable.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final ScanKitController _scankitController = ScanKitController();
  ScanResult? result;
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
  late List<dynamic> rate = [];
  List<dynamic>? offer;

  @override
  void initState() {
    super.initState();
    fetchBalance();

    // Listen to ScanKit results
    _scankitController.onResult.listen((ScanResult result) {
      setState(() {
        this.result = result;
        showResult = true;
        // Process the result and fetch payment details
        getPaymentDetails(result.originalValue, uniqueId);
        _scankitController.pauseContinuouslyScan(); // Stop scanning after a result is found
      });
    });
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  Future<void> fetchBalance() async {
    try {
      final balanceData = await apiServices.fetchBalanceData(uniqueId);
      setState(() {
        balance = balanceData;
      });
    } catch (e) {
      print('Error fetching balance: $e');
    }
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
                  : Stack(
                children: [
                  ScanKitWidget(
                    controller: _scankitController,
                    continuouslyScan: true,
                    boundingBox: Rect.fromLTWH(
                      MediaQuery.of(context).size.width / 2 - 100,
                      MediaQuery.of(context).size.height / 2 - 100,
                      200,
                      200,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _scankitController.switchLight();
                            },
                            icon: Icon(
                              Icons.lightbulb_outline_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _scankitController.pickPhoto();
                            },
                            icon: Icon(
                              Icons.picture_in_picture_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orangeAccent, width: 2),
                      ),
                    ),
                  ),
                ],
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
            Text('Balance: ${balance ?? "Loading..."}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black), textAlign: TextAlign.left,),
            _buildCard("Center Name:", CenterName ?? "N/A"),
            _buildCard("Machine Name:", MachineName ?? "N/A"),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text('Select Payment', style: TextStyle(fontSize: 18)),
                  Container(
                    height: rate.length * 70.0, // Adjust the height dynamically
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
            ),
            _buildCard("Time to On:", TimeToOn ?? "N/A"),
            _buildCard("Offer:", offer != null && offer!.isNotEmpty ? "Discount: ${offer?[0]["discount"]}" : "No Offer Available"),
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
      num finalAmount = amount! - offer![0]["discount"];
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

  Future<void> getPaymentDetails(String machineId, String uniqueId) async {
    print('Register uniqueId========$uniqueId');
    print('payment result code========$machineId');

    try {
      final response = await http.post(
        Uri.parse('${GlobalVariable.baseUrl}/Center/GetMachinePlan'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'userId': uniqueId,
          'machinecode': machineId.toString(),
        }),
      );

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
        print('Request failed with status code ${response.statusCode}');
      }
    } catch (error) {
      print('Request failed with error: $error');
    }
  }

  @override
  void dispose() {
    _scankitController.dispose();
    super.dispose();
  }
}
