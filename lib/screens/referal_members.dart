import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../common_widgets/background_widget.dart';

class ReferalMembers extends StatefulWidget {
  const ReferalMembers({Key? key}) : super(key: key);

  @override
  State<ReferalMembers> createState() => _ReferalMembersState();
}

class _ReferalMembersState extends State<ReferalMembers> {
  List<dynamic> members = [];
  bool isLoading = true;
  final uniqueId = Get.arguments;

  @override
  void initState() {
    super.initState();
    fetchReferralMembers(uniqueId);
  }

  Future<void> fetchReferralMembers(uniqueId) async {
    final String apiUrl =
        'http://scanato.in:88/api/User/GetUserRefMembers?UserId=$uniqueId';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': uniqueId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          members = data;
          isLoading = false;
        });
      } else {
        showErrorDialog(
            'Failed to load members. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showErrorDialog('Error fetching data: $e');
    }
  }

  void showErrorDialog(String message) {
    Get.defaultDialog(
      title: 'Error',
      middleText: message,
      textConfirm: 'OK',
      onConfirm: () => Get.back(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            children: [
              Image.asset(
                'assets/images/robologo.jpg',
                height: 100,
                width: 100,
              ),
              Text('Referral List')
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : members.isEmpty
            ? const Center(child: Text('No members found.'))
            : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(
                    color: Colors.black, // Black border color
                    width: 1, // Border width
                  ),
                  columns: [
                    DataColumn(
                      label: Text(
                        'S.No',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Bold header text
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Bold header text
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Mobile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Bold header text
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  rows: members
                      .asMap()
                      .entries
                      .map(
                        (entry) => DataRow(
                      color: MaterialStateColor.resolveWith(
                            (states) => entry.key % 2 == 0
                            ? Colors.grey.shade200
                            : Colors.white,
                      ), // Alternating row colors
                      cells: [
                        DataCell(
                          Text(
                            (entry.key + 1).toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        DataCell(
                          Text(
                            entry.value['name'] ?? 'No Name',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        DataCell(
                          Text(
                            entry.value['mobile'] ?? 'No Phone',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  )
                      .toList(),
                ),
              ),
            ),
      ),
    );
  }
}
