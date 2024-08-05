import 'package:flutter/material.dart';

import '../models/machinelist_model.dart';
import '../server/apis.dart';

class MachineListView extends StatefulWidget {
  const MachineListView({Key? key}) : super(key: key);

  @override
  State<MachineListView> createState() => _MachineListViewState();
}

class _MachineListViewState extends State<MachineListView> {
  late List<MachineList>? _MachineListModel = [];
  ApiServices apiServices = ApiServices();

  Future<void> getMachineData() async {
    List<MachineList>? MachineData = await apiServices.fetchMachineListOnCenterData();
    setState(() {
      _MachineListModel = MachineData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMachineData();
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
      body: Column(
        children: [
          Container(
            child: const Text(
              'Machine List',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: _buildMachineList()),
        ],
      ),
    );
  }


  Widget _buildMachineList() {
    if (_MachineListModel == null || _MachineListModel!.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        itemCount: _MachineListModel!.length,
        itemBuilder: (context, index) {
          // Adding 1 to index to display 1-based numbering
          int itemNumber = index + 1;

          return Card(
            elevation: 6,
            child: ListTile(
              title: Text('$itemNumber. ${_MachineListModel![index].name ?? ''}'),
              subtitle:  Text('Capacity. ${_MachineListModel![index].capacity ?? ''}'),
              // Add more details as needed
            ),
          );
        },
      );
    }
  }

}
