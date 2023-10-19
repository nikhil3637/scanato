import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scanato/models/machinetype_model.dart';
import 'package:scanato/models/makeid_list.dart';
import 'package:scanato/models/modelid_model.dart';
import 'package:scanato/server/apis.dart';

class AddMachine extends StatefulWidget {
  const AddMachine({Key? key}) : super(key: key);

  @override
  State<AddMachine> createState() => _AddMachineState();
}

class _AddMachineState extends State<AddMachine> {
  late List<MachineType>? _machineTypeModel = [];
  late List<Makeid>? _makeIdModel = [];
  late List<ModelId>? _modelTypeModel = [];
  final ApiServices apiServices = ApiServices();
  final TextEditingController MachineName = TextEditingController();
  final TextEditingController Capacity = TextEditingController();
  final TextEditingController MachineCode = TextEditingController();
  int? selectedMachine;
  int? selectedCompany;
  int? selectedModel;

  Future<void> getMachineData() async {
    List<MachineType>? MachineData = await apiServices.fetchMachineTypeListData();
    setState(() {
      _machineTypeModel = MachineData;
    });
  }

  Future<void> getMakeIdData() async {
    List<Makeid>? MakeIdData = await apiServices.fetchMakeidListData();
    setState(() {
      _makeIdModel = MakeIdData;
    });
  }

  Future<void> getModelListData() async {
    List<ModelId>? MachineData = await apiServices.fetchModelListData();
    setState(() {
      _modelTypeModel = MachineData;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMachineData();
    getMakeIdData();
    getModelListData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    MachineCode.dispose();
    MachineName.dispose();
    Capacity.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uniqueId = Get.arguments;
    return Scaffold(
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
              // Textfield for Machine Name
              TextFormField(
                controller: MachineName,
                decoration: const InputDecoration(
                  labelText: "Machine Name",
                ),
              ),
              SizedBox(height: 20.0),
              // Textfield for Model
              TextFormField(
                controller: Capacity,
                decoration: const InputDecoration(
                  labelText: "Capacity",
                ),
              ),
              SizedBox(height: 20.0),
              // Textfield for Model
              TextFormField(
                controller: MachineCode,
                decoration: const InputDecoration(
                  labelText: "Machine Code",
                ),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<int>(
                value: selectedMachine,
                onChanged: (newValue) {
                  setState(() {
                    selectedMachine = newValue;
                    print('selectedState========$selectedMachine');
                    // selectedCity = null; //
                  });
                },
                items: _machineTypeModel?.map((state) {
                  return DropdownMenuItem<int>(
                    value: state.id,
                    child: Text(state.name),
                  );
                }).toList() ?? [],
                decoration: InputDecoration(labelText: "Machine Type"),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<int>(
                value: selectedCompany,
                onChanged: (newValue) {
                  setState(() {
                    selectedCompany = newValue;
                    print('selectedCompany========$selectedCompany');
                    // selectedCity = null; //
                  });
                },
                items: _makeIdModel?.map((state) {
                  return DropdownMenuItem<int>(
                    value: state.id,
                    child: Text(state.name),
                  );
                }).toList() ?? [],
                decoration: InputDecoration(labelText: "Company"),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<int>(
                value: selectedModel,
                onChanged: (newValue) {
                  setState(() {
                    selectedModel = newValue;
                    print('selectedState========$selectedModel');
                    // selectedCity = null; //
                  });
                },
                items: _modelTypeModel?.map((state) {
                  return DropdownMenuItem<int>(
                    value: state.id,
                    child: Text(state.name),
                  );
                }).toList() ?? [],
                decoration: InputDecoration(labelText: "Model"),
              ),
              ElevatedButton(
                onPressed: () async {
                  bool success = await apiServices.addNewMachine(MachineName.text, selectedCompany, selectedModel, Capacity.text, selectedMachine, MachineCode.text, uniqueId);
                  if (success) {
                    // Clear text fields and reset dropdown selections on success
                    MachineName.clear();
                    Capacity.clear();
                    MachineCode.clear();
                    setState(() {
                      selectedMachine = null;
                      selectedCompany = null;
                      selectedModel = null;
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
