import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants/global_variable.dart';
import '../server/apis.dart';

class AddFamilyMember extends StatefulWidget {
  const AddFamilyMember({Key? key}) : super(key: key);

  @override
  State<AddFamilyMember> createState() => _AddFamilyMemberState();
}

class _AddFamilyMemberState extends State<AddFamilyMember> {
  String? userNameForVerification;
  final ApiServices apiServices = ApiServices();
  final uniqueId = Get.arguments;
  final TextEditingController mobileController = TextEditingController();
  final FocusNode mobileFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    mobileController.addListener(() {
      if (mobileController.text.length == 10) {
        fetchUserNameAndShowDialog(mobileController.text);
        mobileFocusNode.unfocus();
      }
    });
  }

  Future<void> fetchUserNameAndShowDialog(String mobile) async {
    try {
      if (mobile.isEmpty) return;

      final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}/User/GetUserListBymobile/$mobile'));

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        print('Parsed Response Data: $responseData');

        if (responseData['isSuccess'] == true) {
          final userName = responseData['name'];
          final userId = responseData['id'];

          setState(() {
            userNameForVerification = userName;
          });

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('User Name: $userName'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      addMember(userId);
                      Navigator.of(context).pop(); // Close the dialog after adding the member
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        } else {
          setState(() {
            userNameForVerification = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No user found for this mobile number'),
            ),
          );
        }
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Failed to load user data: $e');
    }
  }

  Future<void> addMember(int adminId) async {
    bool success = await apiServices.addFamilyMember(adminId, uniqueId);
    if (success) {
      mobileController.clear();
      setState(() {
        userNameForVerification = null;
      });
    }
  }

  @override
  void dispose() {
    mobileController.dispose();
    mobileFocusNode.dispose();
    super.dispose();
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Enter Mobile Number:'),
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: mobileController,
                        focusNode: mobileFocusNode,
                        decoration: const InputDecoration(
                          labelText: "Mobile Number",
                        ),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
