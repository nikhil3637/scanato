import 'package:flutter/material.dart';
import 'package:scanato/common_widgets/custom_textfield.dart';
import 'package:scanato/server/apis.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController referral = TextEditingController();
  final ApiServices apiServices = ApiServices();


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/robowithlogo.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35,top: 130),
                      child: Column(
                        children: [
                         CustomTextField(controller: name, hintText: "Name"),
                          const SizedBox(
                            height: 20,
                          ),
                         CustomTextField(controller: email, hintText: "Email"),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(controller: mobile, hintText: "Mobile Number"),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(controller: password, hintText: "Password"),
                          const SizedBox(height: 20,),
                          CustomTextField(controller: referral, hintText: "Referral Code"),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      apiServices.registerUser(name.text, email.text, mobile.text, password.text,referral.text);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'login');
                                },
                                style: ButtonStyle(),
                                child: const Text(
                                  'Sign In',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.black,
                                      fontSize: 18),
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
            ),
          ],
        ),
      ),
    );
  }
}