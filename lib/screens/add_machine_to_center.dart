import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scanato/models/centerlist_model.dart';
import 'package:scanato/models/machinelist_model.dart';
import 'package:scanato/server/apis.dart';

class AddMachineToCenter extends StatefulWidget {
  const AddMachineToCenter({Key? key}) : super(key: key);

  @override
  State<AddMachineToCenter> createState() => _AddMachineToCenterState();
}

class _AddMachineToCenterState extends State<AddMachineToCenter> {
  int? selectedMachine;
  int? selectedCenter;
  late List<MachineList>? _machineListModel = [];
  late List<CenterList>? _centerListModel = [];
  ApiServices apiServices = ApiServices();

  Future<void> getMachineData() async {
    List<MachineList>? MachineData = await apiServices.fetchMachineListOnCenterData();
    setState(() {
      _machineListModel = MachineData;
    });
  }

  Future<void> getCenterData() async {
    List<CenterList>? CenterData = await apiServices.fetchCenterListData();
    setState(() {
      _centerListModel = CenterData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMachineData();
    getCenterData();
  }
  @override
  Widget build(BuildContext context) {
    final uniqueId = Get.arguments;
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/robologo.jpg',
          height: 100,
          width: 100,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                isDense: true,
                isExpanded: true,
                value: selectedMachine,
                onChanged: (newValue) {
                  setState(() {
                    selectedMachine = newValue;
                    print('selectedMachine========$selectedMachine');
                  });
                },
                items: _machineListModel?.map((machine) {
                  return DropdownMenuItem<int>(
                    value: machine.id,
                    child: Text(machine.name), // Display the center name
                  );
                }).toList() ?? [],
                decoration: InputDecoration(labelText: "Machine Type"),
              ),


              SizedBox(height: 20.0),
              DropdownButtonFormField<int>(
                isDense: true,
                isExpanded: true,
                value: selectedCenter,
                onChanged: (newValue) {
                  setState(() {
                    selectedCenter = newValue;
                    print('selectedState========$selectedCenter');
                    // selectedCity = null; //
                  });
                },
                items: _centerListModel?.map((state) {
                  return DropdownMenuItem<int>(
                    value: state.id,
                    child: Text(state.name),
                  );
                }).toList() ?? [],
                decoration: InputDecoration(labelText: "Center"),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  bool success =await apiServices.addMachineToCenter(selectedCenter, selectedMachine, uniqueId);
                  if (success) {
                    // Clear text fields and reset dropdown selections on success
                    setState(() {
                      selectedMachine = null;
                      selectedCenter = null;
                    });
                  }
                },
                child: Text("Add Machine"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
