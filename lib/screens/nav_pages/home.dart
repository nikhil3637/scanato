import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/report_model.dart';
import '../../server/apis.dart';

class MyHome extends StatefulWidget {
  final int uniqueId;
  const MyHome({Key? key, required this.uniqueId}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<AnalyticsReport>? _analyticsReportModel = [];
  final ApiServices apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
    getReportData(widget.uniqueId);
  }

  Future<void> getReportData(uniqueId) async {
    List<AnalyticsReport>? reportData =
    await apiServices.fetchReportlistData(uniqueId);
    setState(() {
      _analyticsReportModel = reportData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (_analyticsReportModel != null && _analyticsReportModel!.isNotEmpty)
            Column(
              children: _buildCards(_analyticsReportModel![0]),
            ),
          if (_analyticsReportModel == null || _analyticsReportModel!.isEmpty)
            Center(
              child: Text('No data available'),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildCards(AnalyticsReport reportData) {
    List<Widget> cards = [];

    cards.add(
      Card(
        color: Colors.green.shade200,
        shadowColor: Colors.greenAccent,
        elevation: 6,
        margin: EdgeInsets.all(16.0),
        child: ListTile(
          leading: Icon(Icons.currency_rupee),
          title: Text('Collection: ${reportData.rechargeCollection}'),
        ),
      ),
    );

    cards.add(
      Card(
        color: Colors.orange.shade200,
        shadowColor: Colors.greenAccent,
        elevation: 6,
        margin: EdgeInsets.all(16.0),
        child: ListTile(
          leading: Icon(Icons.person),
          title: Text('Users: ${reportData.totalNoOfUsers}'),
        ),
      ),
    );

    cards.add(
      Card(
        color: Colors.yellow.shade200,
        shadowColor: Colors.greenAccent,
        elevation: 6,
        margin: EdgeInsets.all(16.0),
        child: ListTile(
          leading: Icon(Icons.center_focus_strong),
          title: Text('Centers: ${reportData.totalNoOfCenter}'),
        ),
      ),
    );

    cards.add(
      Card(
        color: Colors.purple.shade200,
        shadowColor: Colors.greenAccent,
        elevation: 6,
        margin: EdgeInsets.all(16.0),
        child: ListTile(
          leading: Icon(Icons.airline_seat_legroom_extra_outlined),
          title: Text('Machines: ${reportData.totalNoOfMachine}'),
        ),
      ),
    );
    return cards;
  }
}
