import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../models/adminbymob_model.dart';
import '../server/apis.dart';

class AddFamilyMember extends StatefulWidget {
  const AddFamilyMember({Key? key}) : super(key: key);

  @override
  State<AddFamilyMember> createState() => _AddFamilyMemberState();
}

class _AddFamilyMemberState extends State<AddFamilyMember> {
  String? userNameForVerification; // Added to store the user's name for verification
  int? selectedAdmin;
  double? balance;
  final ApiServices apiServices = ApiServices();
  final uniqueId = Get.arguments;
  final TextEditingController mobileController = TextEditingController();


  Future<void> fetchUserNameByMobile(String mobile) async {
    try {
      // Check if the mobile number input is empty, and if it is, return without making the API call
      if (mobile.isEmpty) {
        return;
      }

      final response = await http.get(Uri.parse('http://183.83.176.150:88/api/User/GetUserListBymobile/${mobile}'));

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
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () async {
                bool success = await apiServices.addFamilyMember( selectedAdmin, uniqueId);
                if (success) {
                  // Clear text fields and reset dropdown selections on success
                  mobileController.clear();
                  setState(() {
                    selectedAdmin = null;
                    userNameForVerification = null;
                  });
                }
              },
              child: Text('Add Member'),
            ),
          ],
        ),
      ),
    );
  }
}
