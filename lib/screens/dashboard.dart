import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scanato/screens/add_admin.dart';
import 'package:scanato/screens/add_center.dart';
import 'package:scanato/screens/add_machine.dart';
import 'package:scanato/screens/add_machine_to_center.dart';
import 'package:scanato/screens/add_offer.dart';
import 'package:scanato/screens/analytics_report.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final uniqueId = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Image.asset(
          'assets/images/robologo.jpg',
          height: 100,
          width: 100,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15, top: 10),
              child: const Text(
                'Master',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 130,
                    width: 130,
                    child: GestureDetector(
                      onTap: () {
                        Get.to( () => AddAdmin(),fullscreenDialog: true,arguments: uniqueId);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(1),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: const Column(
                            children: [
                              Icon(Icons.admin_panel_settings, size: 50),
                              SizedBox(height: 10),
                              Text('Add Admin'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 130,
                    width: 130,
                    child: GestureDetector(
                      onTap: () {
                        Get.to( () => AddCenter(),fullscreenDialog: true,arguments: uniqueId);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(1),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: const Column(
                            children: [
                              Icon(Icons.add_location, size: 50),
                              SizedBox(height: 10),
                              Text('Add Center'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 130,
                  width: 130,
                  child: GestureDetector(
                    onTap: () {
                      Get.to( () => AddMachine(),fullscreenDialog: true,arguments: uniqueId);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(1),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: const Column(
                          children: [
                            Icon(Icons.add, size: 50),
                            SizedBox(height: 10),
                            Text('  Add New \n   Machine'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 130,
                  width: 130,
                  child: GestureDetector(
                    onTap: () {
                      Get.to( () => AddMachineToCenter(),fullscreenDialog: true,arguments: uniqueId);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(1),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: const Column(
                          children: [
                            Icon(Icons.airline_seat_legroom_extra_outlined, size: 50),
                            SizedBox(height: 10),
                            Text('Add Machine to Center'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),

            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 130,
                  width: 130,
                  child: GestureDetector(
                    onTap: () {
                      Get.to( () => AddOffer(),fullscreenDialog: true,arguments: uniqueId);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(1),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: const Column(
                          children: [
                            Icon(Icons.local_offer, size: 50),
                            SizedBox(height: 10),
                            Text('Add Offer'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 130,
                  width: 130,
                  child: GestureDetector(
                    onTap: () {
                      Get.to( () => Reports(),fullscreenDialog: true,arguments: uniqueId);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(1),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: const Column(
                          children: [
                            Icon(Icons.analytics, size: 50),
                            SizedBox(height: 10),
                            Text('Analytics'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
