import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanato/models/report_model.dart';

import '../server/apis.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  List<AnalyticsReport>? _analyticsReportModel = [];
  final ApiServices apiServices = ApiServices();
  final uniqueId = Get.arguments;

  @override
  void initState() {
    super.initState();
    getReportData(uniqueId);
  }

  Future<void> getReportData(uniqueId) async {
    List<AnalyticsReport>? reportData = await apiServices.fetchReportlistData(uniqueId);
    setState(() {
      _analyticsReportModel = reportData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/robologo.jpg',
          height: 100,
          width: 100,
        ),
      ),
      body: _analyticsReportModel != null && _analyticsReportModel!.isNotEmpty
          ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StatisticCard(
                title: "Recharge Collection",
                value: _analyticsReportModel![0].rechargeCollection.toString(),
              ),
              StatisticCard(
                title: "Total Number of Centers",
                value: _analyticsReportModel![0].totalNoOfCenter.toString(),
              ),
              StatisticCard(
                title: "Total Number of Machines",
                value: _analyticsReportModel![0].totalNoOfMachine.toString(),
              ),
              StatisticCard(
                title: "Total Number of Users",
                value: _analyticsReportModel![0].totalNoOfUsers.toString(),
              ),
            ],
          )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;

  StatisticCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              value,
              style: TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}
