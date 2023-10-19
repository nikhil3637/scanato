import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scanato/models/state_model.dart';
import 'package:scanato/server/apis.dart';
import '../models/admin_model.dart';
import '../models/city_model.dart';

class AddCenter extends StatefulWidget {
  const AddCenter({Key? key}) : super(key: key);

  @override
  State<AddCenter> createState() => _AddCenterState();
}

class _AddCenterState extends State<AddCenter> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  ApiServices apiServices =ApiServices();
  late List<StateModel>? _stateModel = [];
  late List<CityModel>? _cityModel = [];
  late List<Welcome>? _adminModel = [];
  int? selectedState;
  int? selectedCity;
  int? selectedAdmin;
  int? centerCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStateData();
    getCityData();
    getAdminListData();
    getUniqueNo();
  }

  Future<void> getStateData() async {
    List<StateModel>? stateData = await apiServices.fetchStateData();
    setState(() {
      _stateModel = stateData;
    });
  }

  Future<void> getCityData() async {
    List<CityModel>? cityData = await apiServices.fetchCityData();
    setState(() {
      _cityModel = cityData;
    });
  }

  Future<void> getAdminListData() async {
    List<Welcome>? adminData = await apiServices.fetchAdminListData(1);
    setState(() {
      _adminModel = adminData;
    });
  }

  getUniqueNo(){
    final random = Random();
    final number = random.nextInt(1000);
    setState(() {
      centerCode = number;
    });
    print('centerCode=================%$centerCode');

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: const Text(
                  'Add Center',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                ),
              ),
              SizedBox(height: 16),

              // Text field for Address
              DropdownButtonFormField<int>(
                value: selectedState,
                onChanged: (newValue) {
                  setState(() {
                    selectedState = newValue;
                    print('selectedState========$selectedState');
                    // selectedCity = null; //
                  });
                },
                items: _stateModel?.map((state) {
                  return DropdownMenuItem<int>(
                    value: state.id,
                    child: Text(state.name),
                  );
                }).toList() ?? [],
                decoration: InputDecoration(labelText: "State"),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: selectedCity,
                onChanged: (newValue) {
                  setState(() {
                    selectedCity = newValue;
                    print('selectedState========$selectedCity');
                    // selectedCity = null; //
                  });
                },
                items: _cityModel?.map((city) {
                  return DropdownMenuItem<int>(
                    value: city.id,
                    child: Text(city.name),
                  );
                }).toList() ?? [],
                decoration: InputDecoration(labelText: "City"),
              ),
              SizedBox(height: 16,),
              DropdownButtonFormField<int>(
                value: selectedAdmin,
                onChanged: (newValue) {
                  setState(() {
                    selectedAdmin = newValue;
                    print('selectedState========$selectedAdmin');
                    // selectedCity = null; //
                  });
                },
                items: _adminModel?.map((city) {
                  return DropdownMenuItem<int>(
                    value: city.id,
                    child: Text(city.name),
                  );
                }).toList() ?? [],
                decoration: InputDecoration(labelText: "Admin"),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () async {
                  bool success = await apiServices.addCenter(
                    nameController.text,
                    centerCode,
                    selectedState,
                    selectedCity,
                    addressController.text,
                    selectedAdmin,
                    uniqueId,
                  );
                  if (success) {
                    // Clear text fields and reset dropdown selections on success
                    nameController.clear();
                    addressController.clear();
                    setState(() {
                      selectedState = null;
                      selectedCity = null;
                      selectedAdmin = null;
                    });
                  }
                },
                child: Text('Add Center'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}