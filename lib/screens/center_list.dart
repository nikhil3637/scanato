import 'package:flutter/material.dart';
import '../models/centerlist_model.dart';
import '../server/apis.dart';

class CenterListView extends StatefulWidget {
  const CenterListView({Key? key}) : super(key: key);

  @override
  State<CenterListView> createState() => _CenterListViewState();
}

class _CenterListViewState extends State<CenterListView> {
  late List<CenterList>? _centerListModel = [];
  ApiServices apiServices = ApiServices();

  Future<void> getCenterData() async {
    List<CenterList>? centerData = await apiServices.fetchCenterListData();
    setState(() {
      _centerListModel = centerData;
      print('_centerListModel=====================$_centerListModel');
    });
  }

  @override
  void initState() {
    super.initState();
    getCenterData();
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
          )
      ),
      body: _buildCenterList(),
    );
  }

  Widget _buildCenterList() {
    if (_centerListModel == null || _centerListModel!.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        itemCount: _centerListModel!.length,
        itemBuilder: (context, index) {
          // Adding 1 to index to display 1-based numbering
          int itemNumber = index + 1;

          return Card(
            elevation: 6,
            child: ListTile(
              title: Text('$itemNumber. ${_centerListModel![index].name ?? ''}'),
              subtitle:  Text('$itemNumber. ${_centerListModel![index].address ?? ''}'),
              // Add more details as needed
            ),
          );
        },
      );
    }
  }

}
