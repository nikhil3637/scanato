import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/global_variable.dart';
import '../models/admin_model.dart';
import '../models/adminbymob_model.dart';
import '../models/balace_history_model.dart';
import '../models/centerlist_model.dart';
import '../models/city_model.dart';
import '../models/machinelist_model.dart';
import '../models/machinetype_model.dart';
import '../models/makeid_list.dart';
import '../models/modelid_model.dart';
import '../models/offer_type_model.dart';
import '../models/report_model.dart';
import '../models/state_model.dart';


class ApiServices{
  final isLoading = false.obs;

  Future<void> loginUser(name, password) async {
    isLoading.value = true;
    try {
      // Check if name or password is empty
      if (name.isEmpty || password.isEmpty) {
        Get.defaultDialog(
          title: 'Error',
          middleText: 'Name and/or password is empty. Please provide valid credentials.',
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        );
        print('Name and/or password is empty. Please provide valid credentials.');
        return; // Exit the function without making the API call
      }

      final response = await http.post(
        Uri.parse('${GlobalVariable.baseUrl}/User/Login'), // Use the baseUrl constant
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'userName': name.toString(),
          'password': password.toString(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('response login body = $responseData');

        // Rest of your code for successful login
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('id', responseData['id']);
        await prefs.setInt('role', responseData['role']['id']);
        await prefs.setString('rolename', responseData['role']['name']);
        await prefs.setString('name', responseData['name']);
        await prefs.setString('email', responseData['email']);
        await prefs.setString('mobile', responseData['mobile']);
        await prefs.setString('referralCode', responseData['referralCode']);

        final role = responseData['role'];
        final uniqueId = responseData['id'];
        print('uniqueId = $uniqueId');
        print('Role = $role');
        final roleId = role['id'];
        print('roleId = $roleId');
        Get.offNamed('/home');
      } else {
        print('Login failed with status code ${response.statusCode}');
      }
    } finally {
      isLoading.value = false; // Set isLoading to false after login is complete or in case of error
    }
  }

  Future<void> registerUser(name,email,mobile,password,referral) async {
    final bool isEmailVerified =false;
    final bool isMobileVerified =false;
    print('Register name========$name');
    print('Register email========$email');
    print('Register mobile========$mobile');
    print('Register password========$password');
    try {
      final response = await http.post(
          Uri.parse('${GlobalVariable.baseUrl}/User/Registration'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String ,dynamic>{
            'name': name.toString(),
            'email': email.toString(),
            'mobile': mobile.toString(),
            'password': password.toString(),
            'roleId' : 4,
            'createdBy' : 0,
            'entrySource' : 'App',
            'referralCode' : referral.toString(),
            'isEmailVerified' : isEmailVerified,
            'isMobileVerified' : isMobileVerified,
          }
          ));

      if (response.statusCode == 200) {
        // Registration successful, you can process the response here
        final responseData = response.body;
        final decode = jsonDecode(responseData);
        final message = decode['message'];
        if (message == 'success') {
          // Show a success dialog using GetX
          Get.defaultDialog(
            title: 'Success',
            middleText: 'Registered successfully',
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('OK'),
              ),
            ],
          );
        } else {
          Get.defaultDialog(
            title: 'error',
            middleText: message,
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('OK'),
              ),
            ],
          );
        }
        print('Registration Response: ======== $responseData');
        Get.toNamed('/',);
      } else {
        // Handle errors or non-200 status codes here
        print('Registration failed with status code ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions here
      print('Registration failed with error: $error');
    }
  }

  Future<bool> addAdmin(name, email, mobile, password, uniqueId) async {
    isLoading.value = true;
    final bool isEmailVerified = false;
    final bool isMobileVerified = false;
    print('Register name========$name');
    print('Register email========$email');
    print('Register mobile========$mobile');
    print('Register password========$password');

    try {
      final response = await http.post(
          Uri.parse('${GlobalVariable.baseUrl}/User/Registration'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            'name': name.toString(),
            'email': email.toString(),
            'mobile': mobile.toString(),
            'password': password.toString(),
            'roleId': 1,
            'createdBy': uniqueId,
            'entrySource': 'App',
            'referralCode': '$name$uniqueId',
            'isEmailVerified': isEmailVerified,
            'isMobileVerified': isMobileVerified,
          }));

      if (response.statusCode == 200) {
        // Registration successful, you can process the response here
        final responseData = response.body;
        final decode = jsonDecode(responseData);
        final message = decode['message'];
        print('Registration Response: ======== $responseData');
        if (message == 'success') {
          // Show a success dialog using GetX
          Get.defaultDialog(
            title: 'Success',
            middleText: 'Admin added successfully',
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('OK'),
              ),
            ],
          );
          return true;
        } else {
          Get.defaultDialog(
            title: 'error',
            middleText: message,
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('OK'),
              ),
            ],
          );
        }
      } else {
        // Handle errors or non-200 status codes here
        print('Registration failed with status code ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions here
      print('Registration failed with error: $error');
    }
    isLoading.value = false;
    return false; // Return failure flag
  }

  Future<bool> addCenter(name,centerCode,stateId,cityId,address,adminId,uniqueId) async {
    print('Register name========$name');
    print('Register centerCode========$centerCode');
    print('Register stateId========$stateId');
    print('Register cityId========$cityId');
    print('Register address========$address');
    print('Register adminId========$adminId');
    print('Register uniqueId========$uniqueId');

    try {
      final response = await http.post(
          Uri.parse('${GlobalVariable.baseUrl}/Master/AddCenter'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String ,dynamic>{
            'name': name.toString(),
            'code': centerCode.toString(),
            'stateId': stateId,
            'cityId': cityId,
            'address' : address.toString(),
            'adminId' : adminId,
            'created_By' : uniqueId,
          }
          ));
      if (response.statusCode == 200) {
        // Registration successful, you can process the response here
        final responseData = response.body;
        print('Registration Response: ======== $responseData');

        // Show a success dialog using GetX
        Get.defaultDialog(
          title: 'Success',
          middleText: 'Center added successfully',
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        );
        return true;
      }
      else {
        // Handle errors or non-200 status codes here
        print('Registration failed with status code ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions here
      print('Registration failed with error: $error');
    }
    return false;
  }

  Future<bool> addNewMachine(name,makeId,modelId,capacity,machineType,machineCode,uniqueId) async {
    print('Register name========$name');
    print('Register makeId========$makeId');
    print('Register modelId========$modelId');
    print('Register capacity========$capacity');
    print('Register machineType========$machineType');
    print('Register machineCode========$machineCode');
    print('Register uniqueId========$uniqueId');

    try {
      final response = await http.post(
          Uri.parse('${GlobalVariable.baseUrl}/Master/AddMachine'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String ,dynamic>{
            'name': name.toString(),
            'makeId': makeId,
            'modelId': modelId,
            'capacity': capacity,
            'machineType' : machineType,
            'machineCode' : machineCode.toString(),
            'created_By' : uniqueId,
          }
          ));

      if (response.statusCode == 200) {
        // Registration successful, you can process the response here
        final responseData = response.body;
        print('Registration Response: ======== $responseData');

        // Show a success dialog using GetX
        Get.defaultDialog(
          title: 'Success',
          middleText: 'New Machine added successfully',
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        );
        return true;
      }
      else {
        // Handle errors or non-200 status codes here
        print('Registration failed with status code ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions here
      print('Registration failed with error: $error');
    }
    return false;
  }

  Future<bool> addMachineToCenter(centerId,machineId,uniqueId,) async {
    print('Register uniqueId========$uniqueId');

    try {
      final response = await http.post(
          Uri.parse('${GlobalVariable.baseUrl}/Center/AddMachines'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String ,dynamic>{
            'centerId': centerId,
            'machineIds': machineId.toString(),
            'created_By' : uniqueId,
            'entrySource' : 'App'
          }
          ));

      if (response.statusCode == 200) {
        // Registration successful, you can process the response here
        final responseData = response.body;
        print('Registration Response: ======== $responseData');

        // Show a success dialog using GetX
        Get.defaultDialog(
          title: 'Success',
          middleText: ' Machine added ',
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        );
        return true;
      }
      else {
        // Handle errors or non-200 status codes here
        print('Registration failed with status code ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions here
      print('Registration failed with error: $error');
    }
    return false;
  }

  Future<bool> rechargeAdmin(amount,userId,uniqueId,) async {
    print('rechargeAdmin=======$uniqueId');
    print('rechargeAdmin=======$amount');
    print('rechargeAdmin=======$userId');

    try {
      final response = await http.post(
          Uri.parse('${GlobalVariable.baseUrl}/wallet/walletrecharge'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String ,dynamic>{
            'amount': amount,
            'userId': userId,
            'txBy' : uniqueId,
            'tcMode' : 'cash'
          }
          ));

      if (response.statusCode == 200) {
        // Registration successful, you can process the response here
        final responseData = response.body;
        print('Registration Response: ======== $responseData');

        // Show a success dialog using GetX
        Get.defaultDialog(
          title: 'Success',
          middleText: 'Recharge Successful ',
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        );
        return true;
      }
      else {
        // Handle errors or non-200 status codes here
        print('Registration failed with status code ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions here
      print('Registration failed with error: $error');
    }
    return false;
  }

  Future<bool> PayByUser(amount,uniqueId,machineCode,centerId,timeToOn,PlanName,selectedDiscount) async {
    try {
      final response = await http.post(
          Uri.parse('https://vedantifosoft.com/api/Machine'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String ,dynamic>{
            'machineId': machineCode,
            'centerId': centerId,
            'amount' : amount,
            'UserId' : uniqueId,
            'TimeToOn' : timeToOn,
            'planName' : PlanName,
            'discount' : selectedDiscount
          }
          ));

      if (response.statusCode == 200) {
        // Registration successful, you can process the response here
        final responseData = response.body;

        // Show a success dialog using GetX
        Get.defaultDialog(
          title: 'Success',
          middleText: 'Payment done Successfully : ${responseData.toString()} ',
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        );
        return true;
      }
      else {
        // Handle errors or non-200 status codes here
        print('Registration failed with status code ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions here
      print('Registration failed with error: $error');
    }
    return false;
  }

  Future<bool> addFamilyMember(userId,uniqueId,) async {
    print('rechargeAdmin=======$uniqueId');
    print('rechargeAdmin=======$userId');

    try {
      final response = await http.post(
          Uri.parse('${GlobalVariable.baseUrl}/user/addfamilymember'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String ,dynamic>{
            'userId': uniqueId,
            'familyMemberId' : userId,
          }
          ));

      if (response.statusCode == 200) {
        // Registration successful, you can process the response here
        final responseData = response.body;
        print('Registration Response: ======== $responseData');

        // Show a success dialog using GetX
        Get.defaultDialog(
          title: 'Success',
          middleText: 'Member Adeded Successfully ',
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        );
        return true;
      }
      else {
        // Handle errors or non-200 status codes here
        print('Registration failed with status code ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions here
      print('Registration failed with error: $error');
    }
    return false;
  }

  Future<bool> AddOffer(centerId,machineId,offerId,discount,startDate,endDate,uniqueID) async {
    final startDateString = startDate.toIso8601String();
    final endDateString = endDate.toIso8601String();

    print('AddOffer==================$AddOffer=========called');
    print('rechargeAdmin=======$centerId');
    print('machineId=======$machineId');
    print('offerId=======$offerId');
    print('discount=======$discount');
    print('startDate=======$startDate');
    print('endDate=======$endDate');
    print('uniqueID=======$uniqueID');

    try {
      final response = await http.post(
          Uri.parse('${GlobalVariable.baseUrl}/master/addofferchart'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String ,dynamic>{
            'centerId': centerId,
            'machineId': machineId,
            'discount' : discount,
            'offertypeId' : offerId,
            'effectiveDateFrom' : startDateString,
            'effectiveDateTo' : endDateString,
            'crewated_By' : uniqueID,
          }
          ));

      if (response.statusCode == 200) {
        // Registration successful, you can process the response here
        final responseData = response.body;
        print('Registration Response: ======== $responseData');

        // Show a success dialog using GetX
        Get.defaultDialog(
          title: 'Success',
          middleText: 'Offer Added Successfully ',
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        );
        return true;
      }
      else {
        // Handle errors or non-200 status codes here
        print('Registration failed with status code ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions here
      print('Registration failed with error: $error');
    }
    return false;
  }

  Future<List<StateModel>> fetchStateData() async {
    final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}/Master/GetStateList'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];

      // Use map to convert the List<dynamic> into a List<StateModel>
      List<StateModel> stateList = responseData.map((stateData) {
        return StateModel.fromJson(stateData);
      }).toList();

      print('responseData================$responseData');
      return stateList;
    } else {
      throw Exception('Failed to load state data');
    }
  }

  Future<List<CityModel>> fetchCityData() async {
    final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}/Master/GetDistrictList'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];

      List<CityModel> stateList = responseData.map((stateData) {
        return CityModel.fromJson(stateData);
      }).toList();

      print('responseData================$responseData');
      return stateList;
    } else {
      throw Exception('Failed to load state data');
    }
  }

  Future<List<Welcome>> fetchAdminListData(id) async {
    print('fetchAdminListData========called');
    final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}/User/GetUserListByRole/${id}'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      List<Welcome> adminList = responseData.map((stateData) {
        return Welcome.fromJson(stateData);
      }).toList();

      print('responseData================$responseData');
      return adminList;
    } else {
      throw Exception('Failed to load state data');
    }
  }

  Future<List<AdminListByMobile>> fetchAdminDataByMobile( mobile) async {
    try {
      print('fetchAdminDataByMobile called');
      final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}/User/GetUserListBymobile/${mobile}'));

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        // If the response is a single object, convert it into a list with a single item
        if (responseData is Map<String, dynamic>) {
          return [AdminListByMobile.fromJson(responseData)];
        } else if (responseData is List) {
          // If the response is already a list, map it to a list of AdminListByMobile objects
          return responseData.map((data) => AdminListByMobile.fromJson(data)).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load admin data');
      }
    } catch (e) {
      print('Error fetching admin data: $e');
      throw Exception('Failed to load admin data: $e');
    }
  }


  Future<List<MachineType>> fetchMachineTypeListData() async {
    print('fetchMachineTypeListData========called');
    final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}/master/getmachinetypelist'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      List<MachineType> MachineList = responseData.map((stateData) {
        return MachineType.fromJson(stateData);
      }).toList();

      print('responseData================$responseData');
      return MachineList;
    } else {
      throw Exception('Failed to load state data');
    }
  }

  Future<List<Makeid>> fetchMakeidListData() async {
    print('fetchMakeidListData========called');
    final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}/master/getmakelist'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      List<Makeid> MakeidList = responseData.map((stateData) {
        return Makeid.fromJson(stateData);
      }).toList();

      print('fetchMakeidListData================$responseData');
      return MakeidList;
    } else {
      throw Exception('Failed to load state data');
    }
  }

  Future<List<ModelId>> fetchModelListData() async {
    print('fetchModelListData========called');
    final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}/master/getmodellist'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      List<ModelId> ModelList = responseData.map((stateData) {
        return ModelId.fromJson(stateData);
      }).toList();

      print('fetchModelListData================$responseData');
      return ModelList;
    } else {
      throw Exception('Failed to load state data');
    }
  }

  Future<List<MachineList>> fetchMachineListOnCenterData() async {
    print('fetchModelListData========called');
    final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}/master/getmachinelist'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      List<MachineList> machinelist = responseData.map((stateData) {
        return MachineList.fromJson(stateData);
      }).toList();

      print('machinelist================$responseData');
      return machinelist;
    } else {
      throw Exception('Failed to load state data');
    }
  }

  Future<List<CenterList>> fetchCenterListData() async {
    print('fetchModelListData========called');
    final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}/master/getcenterlist'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      List<CenterList> centerlist = responseData.map((stateData) {
        return CenterList.fromJson(stateData);
      }).toList();

      print('machinelist================$responseData');
      return centerlist;
    } else {
      throw Exception('Failed to load state data');
    }
  }

  Future<List<BalanceHis>> fetchBalanceHistoryData(uniqueId) async {
    print('fetchBalanceHistoryData========called');
    final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}/wallet/getwalletdetails/${uniqueId}'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      print('responsedata of history ==============$responseData');
      List<BalanceHis> balancelist = responseData.map((stateData) {
        return BalanceHis.fromJson(stateData);
      }).toList();

      print('balancelist================$responseData');
      return balancelist;
    } else {
      throw Exception('Failed to load state data');
    }
  }

  Future<List<OfferType>> fetchOfferTypelistData() async {
    print('fetchBalanceHistoryData========called');
    final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}/master/getoffertypelist'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      List<OfferType> Offerlist = responseData.map((stateData) {
        return OfferType.fromJson(stateData);
      }).toList();

      print('Offerlist================$responseData');
      return Offerlist;
    } else {
      throw Exception('Failed to load state data');
    }
  }

  Future<List<AnalyticsReport>> fetchReportlistData(uniqueId) async {
    print('fetchReportlistData========called');
    final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}/dashboard/getdashboarddata/${uniqueId}'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      List<AnalyticsReport> Reportlist = responseData.map((stateData) {
        return AnalyticsReport.fromJson(stateData);
      }).toList();

      print('Report Data================$responseData');
      return Reportlist;
    } else {
      throw Exception('Failed to load state data');
    }
  }

  Future<double?> fetchBalanceData(uniqueId) async {
    try {
      final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}/wallet/getwalletbalance/${uniqueId}'));
      final decodedData = jsonDecode(response.body);
      final balance = decodedData['balance'];
      return balance;
    } catch (e) {
      print('Error fetching balance: $e');
    }
    return null;
  }
}
