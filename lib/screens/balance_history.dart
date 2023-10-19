import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scanato/server/apis.dart';
import '../models/balace_history_model.dart';

class BalanceHistory extends StatefulWidget {
  const BalanceHistory({Key? key}) : super(key: key);

  @override
  State<BalanceHistory> createState() => _BalanceHistoryState();
}

class _BalanceHistoryState extends State<BalanceHistory> {
  List<BalanceHis>? _balanceHistoryModel = [];
  final ApiServices apiServices = ApiServices();
  final uniqueId = Get.arguments;
  @override
  void initState() {
    super.initState();
    getBalanceHistoryData(uniqueId);
  }

  Future<void> getBalanceHistoryData(uniqueId) async {
    List<BalanceHis>? balanceData = await apiServices.fetchBalanceHistoryData(uniqueId);
    setState(() {
      _balanceHistoryModel = balanceData;
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
      body: _balanceHistoryModel != null && _balanceHistoryModel!.isNotEmpty
          ? ListView.builder(
        itemCount: _balanceHistoryModel!.length,
        itemBuilder: (context, index) {
          final transaction = _balanceHistoryModel![index];
          return TransactionCard(transaction: transaction);
        },
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final BalanceHis transaction;

  TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(
          'Transaction No: ${transaction.txNo}',
          style: TextStyle(fontWeight: FontWeight.bold), // Make the text bold
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transaction Date: ${transaction.txDate.toString()}',style: TextStyle(color: Colors.black)),
            Text('Debit: ${transaction.dr.toString()}',style: TextStyle(color: Colors.black),),
            Text('Credit: ${transaction.cr.toString()}',style: TextStyle(color: Colors.black)),
            Text(
              'Transaction By: ${transaction.txBy.name.toString().split('.').last}',
              style: TextStyle(fontWeight: FontWeight.bold), // Make the text bold
            ),
          ],
        ),
      ),
    );
  }
}
