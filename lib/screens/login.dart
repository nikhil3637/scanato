import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scanato/screens/register.dart';
import 'package:scanato/server/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  bool isChecked = false;
  bool isPasswordVisible = false;
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final ApiServices apiServices = ApiServices();
  bool isLoading = false;

  Future<void> Remember(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember', value);
    if (value) {
      await prefs.setString('username', name.text);
      await prefs.setString('password', password.text);
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
    }
  }

  Future<bool> checkRemember() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('remember') ?? false;
  }

  void _loginUser() {
    setState(() {
      isLoading = true; // Show the CircularProgressIndicator
    });

    apiServices.loginUser(name.text, password.text).then((result) {
      // Handle the result of the login request
      setState(() {
        isLoading = false; // Hide the CircularProgressIndicator
      });
    }).catchError((error) {
      // Handle login error here

      Get.defaultDialog(
        title: 'Error',
        middleText: 'Mobile number or Password is incorrect',
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('OK'),
          ),
        ],
      );

      setState(() {
        isLoading = false; // Hide the CircularProgressIndicator
      });
    });
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    // Check if user should be remembered and update the state accordingly
    checkRemember().then((bool remembered) {
      setState(() {
        isChecked = remembered;
      });
      if (remembered) {
        // If user should be remembered, automatically fill in the credentials
        fillCredentials();
      }
    });
  }

  void fillCredentials() {
    // Retrieve saved credentials and fill in the text fields
    final prefs = SharedPreferences.getInstance();
    prefs.then((SharedPreferences prefs) {
      setState(() {
        name.text = prefs.getString('username') ?? '';
        password.text = prefs.getString('password') ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/robowithlogo.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.45,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextField(
                              controller: name,
                              decoration: InputDecoration(
                                hintText: 'Mobile',
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextField(
                              controller: password,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: togglePasswordVisibility,
                                  icon: Icon(
                                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              obscureText: !isPasswordVisible,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked = value!;
                                          Remember(value);
                                        });
                                      },
                                    ),
                                    Text('Remember me'),
                                  ],
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color(0xff4c505b),
                                  child: IconButton(
                                    color: Colors.white,
                                    onPressed: _loginUser, // Disable button while loading
                                    icon: const Icon(Icons.arrow_forward),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyRegister()));
                                  },
                                  style: ButtonStyle(),
                                  child: const Text(
                                    'Sign Up',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                // "Powered by" and copyright notice
                Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        'Powered by Vedant Infosoft & Solution PVT LTD',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '© 2023 . All rights reserved.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
