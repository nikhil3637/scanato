import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanato/models/offer_type_model.dart';

import '../models/centerlist_model.dart';
import '../models/machinelist_model.dart';
import '../server/apis.dart';

class AddOffer extends StatefulWidget {
  const AddOffer({Key? key}) : super(key: key);

  @override
  State<AddOffer> createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  int? selectedMachine;
  int? selectedCenter;
  int? selectedOfferType;
  late List<MachineList>? _machineListModel = [];
  late List<CenterList>? _centerListModel = [];
  late List<OfferType>? _offerListModel = [];
  ApiServices apiServices = ApiServices();
  final TextEditingController discountController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  Future<void> getMachineData() async {
    List<MachineList>? machineData = await apiServices.fetchMachineListOnCenterData();
    setState(() {
      _machineListModel = machineData;
    });
  }

  Future<void> getCenterData() async {
    List<CenterList>? centerData = await apiServices.fetchCenterListData();
    setState(() {
      _centerListModel = centerData;
    });
  }

  Future<void> getOfferListData() async {
    List<OfferType>? offerData = await apiServices.fetchOfferTypelistData();
    setState(() {
      _offerListModel = offerData;
    });
  }

  @override
  void initState() {
    super.initState();
    getMachineData();
    getCenterData();
    getOfferListData();
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
              SizedBox(height: 20.0),
              DropdownButtonFormField<int>(
                isDense: true,
                isExpanded: true,
                value: selectedCenter,
                onChanged: (newValue) {
                  setState(() {
                    selectedCenter = newValue;
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
              DropdownButtonFormField<int>(
                isDense: true,
                isExpanded: true,
                value: selectedMachine,
                onChanged: (newValue) {
                  setState(() {
                    selectedMachine = newValue;
                  });
                },
                items: _machineListModel?.map((machine) {
                  return DropdownMenuItem<int>(
                    value: machine.id,
                    child: Text(machine.name),
                  );
                }).toList() ?? [],
                decoration: InputDecoration(labelText: "Machine"),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<int>(
                isDense: true,
                isExpanded: true,
                value: selectedOfferType,
                onChanged: (newValue) {
                  setState(() {
                    selectedOfferType = newValue;
                  });
                },
                items: _offerListModel?.map((machine) {
                  return DropdownMenuItem<int>(
                    value: machine.id,
                    child: Text(machine.name),
                  );
                }).toList() ?? [],
                decoration: InputDecoration(labelText: "Offer Type"),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: discountController,
                decoration: InputDecoration(
                  labelText: "Discount",
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            startDate = selectedDate;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54, // Set the background color here
                      ),
                      child: Text(
                        "Select Start Date",
                        style: TextStyle(color: Colors.white), // Set the text color
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            endDate = selectedDate;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors. black54, // Set the background color here
                      ),
                      child: Text(
                        "Select End Date",
                        style: TextStyle(color: Colors.white), // Set the text color
                      ),
                    ),
                  ),
                ],
              ),
              if (startDate != null && endDate != null)
                Text("Start Date: ${startDate.toString()} - End Date: ${endDate.toString()}"),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                 bool success = await apiServices.AddOffer(selectedCenter, selectedMachine, selectedOfferType, discountController.text, startDate, endDate, uniqueId);
                 if (success) {
                   // Clear text fields and reset dropdown selections on success
                   discountController.clear();
                   setState(() {
                     selectedMachine = null;
                     selectedCenter = null;
                     selectedOfferType = null;
                     startDate = null;
                     endDate = null;
                   });
                 }
                },
                child: Text("Add Offer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
