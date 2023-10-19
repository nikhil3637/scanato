import 'package:flutter/material.dart';
import 'package:scanato/screens/register.dart';
import 'package:scanato/server/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common_widgets/custom_textfield.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  bool isChecked = false;
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final ApiServices apiServices = ApiServices();

  Future<void> Remember() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember', true);
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        CustomTextField(controller: name, hintText: 'Mobile',),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomTextField(controller: password, hintText: "Password",obscureText: true,),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Remember Me", style: TextStyle(color: Colors.black),),
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                isChecked = !isChecked;
                                setState(() {
                                  Remember();
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Sign in',
                              style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xff4c505b),
                              child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  apiServices.loginUser(name.text, password.text);
                                },
                                icon: const Icon(Icons.arrow_forward),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40,
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
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Forgot Password',
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
          ],
        ),
      ),
    );
  }
}
