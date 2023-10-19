import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert';
import '../models/adminbymob_model.dart';
import '../server/apis.dart';

class Recharge extends StatefulWidget {
  final int roleId;
  const Recharge({Key? key, required this.roleId}) : super(key: key);

  @override
  State<Recharge> createState() => _RechargeState();
}

class _RechargeState extends State<Recharge> {
  String? userNameForVerification; // Added to store the user's name for verification
  int? selectedAdmin;
  double? balance;
  final ApiServices apiServices = ApiServices();
  final uniqueId = Get.arguments;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

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

  // Function to fetch the user's name by mobile number
  Future<void> fetchUserNameByMobile(String mobile) async {
    try {
      // Check if the mobile number input is empty, and if it is, return without making the API call
      if (mobile.isEmpty) {
        return;
      }

      final response = await http.get(Uri.parse('http://124.123.76.123:88/api/User/GetUserListBymobile/${mobile}'));

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is List && responseData.isNotEmpty) {
          // If the response is a list and not empty, update the userNameForVerification
          setState(() {
            userNameForVerification = responseData[0]['name'];
          });
        } else {
          // If no user was found for the mobile number, reset userNameForVerification
          setState(() {
            userNameForVerification = null;
          });
        }
      } else {
        throw Exception('Failed to load admin data');
      }
    } catch (e) {
      print('Error fetching admin data: $e');
      throw Exception('Failed to load admin data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/robologo.jpg',
          height: 100,
          width: 100,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 20,),
            // Card to display balance
            Card(
              color: Colors.greenAccent.shade200,
              shadowColor: Colors.greenAccent,
              elevation: 6,
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Balance: ${balance}'),
              ),
            ),
            SizedBox(height: 20,),
            // Mobile Number Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter Mobile Number:'),
                Row(
                  children: [
                    Flexible(
                      child: TypeAheadFormField<AdminListByMobile>(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: mobileController,
                          decoration: InputDecoration(
                            labelText: "Mobile Number",
                          ),
                        ),
                        suggestionsCallback: (pattern) async {
                          // Implement your logic to fetch suggestions based on the mobile number pattern
                          return await apiServices.fetchAdminDataByMobile(pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion.mobile),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          // Handle the selection of a user from the suggestions
                          setState(() {
                            mobileController.text = suggestion.mobile;
                            selectedAdmin = suggestion.id;
                            userNameForVerification = suggestion.name;
                          });
                        },
                        noItemsFoundBuilder: (context) {
                          return SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Display the user's name for verification
            if (userNameForVerification != null)
              Text(
                'User Name : $userNameForVerification',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 20,),
            // Textfield for entering amount
            TextFormField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: "Amount",
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () async {
                if (widget.roleId == 1 && balance != null) {
                  // If roleId is 1, check if the entered amount is less than or equal to the balance
                  double enteredAmount = double.tryParse(amountController.text) ?? 0.0;
                  if (enteredAmount <= balance!) {
                    bool success = await apiServices.rechargeAdmin(amountController.text, selectedAdmin, uniqueId);
                    if (success) {
                      // Clear text fields and reset dropdown selections on success
                      amountController.clear();
                      mobileController.clear();
                      setState(() {
                        selectedAdmin = null;
                        userNameForVerification = null;
                      });
                    }
                  } else {
                    // Show an error message or handle the case where the entered amount is greater than the balance
                    // You can display a snackbar or show an error message here.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Entered amount exceeds available balance.'),
                      ),
                    );
                  }
                } else if (widget.roleId == 2) {
                  // If roleId is 2, allow recharging any amount
                  bool success = await apiServices.rechargeAdmin(amountController.text, selectedAdmin, uniqueId);
                  if (success) {
                    // Clear text fields and reset dropdown selections on success
                    amountController.clear();
                    mobileController.clear();
                    setState(() {
                      selectedAdmin = null;
                      userNameForVerification = null;
                    });
                  }
                }
              },
              child: Text('Recharge'),
            ),
          ],
        ),
      ),
    );
  }
}
