import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

import '../../common_widgets/background_widget.dart';

class Account extends StatefulWidget {
  final String email;
  final String phoneNumber;
  final String roleName;
  final String referral;
  const Account({Key? key, required this.email, required this.phoneNumber, required this.roleName, required this.referral,}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {

  Future<void> rempoveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('role');
    await prefs.remove('rolename');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('mobile');
    await prefs.remove('remember');
    await prefs.remove('referral');
    Get.offNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 200,
                padding: EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: const CircleAvatar(
                  radius: 40,
                ),
              ),
              SizedBox(height: 20),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16),
                elevation: 4,
                shadowColor: Colors.blueGrey,
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Role'),
                  subtitle: Text(widget.roleName),
                  onTap: () {
                    // Add your email handling code here
                  },
                ),
              ),
              SizedBox(height: 20),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16),
                elevation: 4,
                shadowColor: Colors.blueGrey,
                child: ListTile(
                  leading: Icon(Icons.email),
                  title: Text('Email'),
                  subtitle: Text(widget.email),
                  onTap: () {
                    // Add your email handling code here
                  },
                ),
              ),
        
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shadowColor: Colors.blueGrey,
                child: ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('Phone'),
                  subtitle: Text(widget.phoneNumber),
                  onTap: () {
                    // Add your phone handling code here
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shadowColor: Colors.blueGrey,
                child: ListTile(
                  trailing: Icon(Icons.share),
                  leading: Icon(Icons.phone),
                  title: Text('Referral Code'),
                  subtitle: Text(widget.referral),
                  onTap: () {
                    Share.share(widget.referral);
                  },
                ),
              ),
        
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shadowColor: Colors.blueGrey,
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('About'),
                  onTap: () {
                    // Add your "About" handling code here
                  },
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shadowColor: Colors.blueGrey,
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    rempoveUserData();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
