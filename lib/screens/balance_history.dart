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

  int itemsToShow = 10;

  @override
  void initState() {
    super.initState();
    getBalanceHistoryData(uniqueId);

  }

  Future<void> getBalanceHistoryData(uniqueId) async {
    List<BalanceHis>? balanceData =
    await apiServices.fetchBalanceHistoryData(uniqueId);
    setState(() {
      // Filter out transactions with both dr and cr equal to zero
      _balanceHistoryModel = balanceData
          ?.where((transaction) => transaction.dr > 0 || transaction.cr > 0)
          .toList();
    });
  }

  void loadMoreItems() {
    setState(() {
      itemsToShow += 10;
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
          ? Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: itemsToShow,
              itemBuilder: (context, index) {
                if (index == itemsToShow - 1) {
                  return Column(
                    children: [
                      TransactionCard(transaction: _balanceHistoryModel![index]),
                      if (itemsToShow < _balanceHistoryModel!.length)
                        ElevatedButton(
                          onPressed: loadMoreItems,
                          child: Text('Load More'),
                        ),
                    ],
                  );
                }
                final transaction = _balanceHistoryModel![index];
                return TransactionCard(transaction: transaction);
              },
            ),
          ),
        ],
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
    // Check if both dr and cr are greater than zero
    if (transaction.dr > 0 || transaction.cr > 0) {
      return Card(
        margin: EdgeInsets.all(10),
        child: ListTile(
          title: Text(
            'Transaction No: ${transaction.txNo}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Transaction Date: ${transaction.txDate.toString()}', style: TextStyle(color: Colors.black)),
              if (transaction.dr > 0) Text('Debit: ${transaction.dr.toString()}', style: TextStyle(color: Colors.black)),
              if (transaction.cr > 0) Text('Credit: ${transaction.cr.toString()}', style: TextStyle(color: Colors.black)),
              Text(
                'Transaction By: ${transaction.txBy.name.toString().split('.').last}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    } else {
      // Return an empty container for transactions with both dr and cr equal to zero
      return Container();
    }
  }
}

