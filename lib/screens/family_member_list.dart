import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../constants/global_variable.dart';

class FamilyMemberList extends StatefulWidget {
  const FamilyMemberList({Key? key}) : super(key: key);

  @override
  State<FamilyMemberList> createState() => _FamilyMemberListState();
}

class _FamilyMemberListState extends State<FamilyMemberList> {
  final uniqueId = Get.arguments;
  List<dynamic> familyMembers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReportlistData(uniqueId);
  }

  Future<void> fetchReportlistData(uniqueId) async {
    print('fetchReportlistData========called');
    final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}/user/getuserfamilymembers/$uniqueId'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];

      setState(() {
        familyMembers = responseData;
        isLoading = false;
      });

      print('Report Data================$responseData');
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle the error, maybe show a Snackbar or a dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/images/robologo.jpg',
              height: 100,
              width: 100,
            ),
            Text('Family Members')
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : familyMembers.isEmpty
          ? Center(child: Text('No family members found'))
          : ListView.builder(
        itemCount: familyMembers.length,
        itemBuilder: (context, index) {
          final member = familyMembers[index]['family'];
          return Card(
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member['name'] ?? 'Unknown Name',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Email: ${member['email'] ?? 'No Email'}'),
                  Text('Phone: ${member['mobile'] ?? 'No Phone'}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
