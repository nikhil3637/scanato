import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scanato/constants/global_variable.dart';
import 'package:scanato/screens/add_family_member.dart';
import 'package:scanato/screens/nav_pages/account.dart';
import 'package:scanato/screens/nav_pages/home.dart';
import 'package:scanato/screens/nav_pages/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
   int roleId = 0;
   int uniqueId =0;
   String? email;
   String? phoneNumber;
   String? roleName;
   String? referral;
   bool? isloggedIn;
  late PageController pageController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uniqueId = prefs.getInt('id')!;
      roleId = prefs.getInt('role')! ;
      email = prefs.getString('email')!;
      phoneNumber = prefs.getString('mobile')!;
      roleName = prefs.getString('rolename')!;
      isloggedIn = prefs.getBool('remember');
      referral = prefs.getString('referral')!;
      print('referral=============$referral');
    });
  }


  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: pageIndex);
    loadUserData();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('roleid ======on homepage through SP========$roleId');
    print('uniqueId ======on homepage through SP========$uniqueId');
    return Scaffold(
      key: scaffoldKey, // Add a key to the scaffold
      appBar:AppBar(
        backgroundColor: Colors.white,
       elevation: 0,
       centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Image.asset(
          'assets/images/robologo.jpg', // Replace with the path to your logo image
          height: 100,
          width: 100,
        ),
      ),
      drawer: Drawer(
        width: 250,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: GlobalVariable.secondaryColor,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {

              },
            ),
            ListTile(
              leading: Icon(Icons.wallet),
              title: const Text('Wallet'),
              onTap: () {
                // Handle Wallet onTap
              },
            ),
            Visibility(
              visible: roleId == 2, // Only show if roleId is 2
              child: ListTile(
                leading: Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () {
                  Get.toNamed('/dashboard',arguments: uniqueId );
                },
              ),
            ),
            Visibility(
              visible: roleId == 4, // Only show if roleId is 2
              child: ListTile(
                leading: Icon(Icons.family_restroom),
                title: const Text('Family Member'),
                onTap: () {
                  Get.to( () => AddFamilyMember(),fullscreenDialog: true,arguments: uniqueId);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            pageIndex = index;
          });
          pageController.jumpToPage(index);
        },
        currentIndex: pageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        children: <Widget>[
          MyHome(uniqueId: uniqueId,),
          Wallet(uniqueId: uniqueId, roleId: roleId,),
          Account(email: email.toString(), phoneNumber: phoneNumber.toString(), roleName: roleName.toString(), referral: referral.toString(),)
        ],
      ),

    );
  }
}
