import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scanato/screens/pay.dart';
import '../balance_history.dart';
import '../recharge.dart';

class Wallet extends StatefulWidget {
  final int roleId;
  final int uniqueId;
  const Wallet({Key? key, required this.uniqueId, required this.roleId}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _fetchVersion();
  }

  Future<void> _fetchVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
    _showVersionDialog();
  }

  void _showVersionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('App Version'),
          content: Text('Version: $_version'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final uniqueId = widget.uniqueId;
    print('uniqueId=====on wallet =======$uniqueId');
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Visibility(
                    visible: widget.roleId == 1 || widget.roleId ==2,
                    child: Container(
                      height: 130,
                      width: 130,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => Recharge(roleId: widget.roleId,), fullscreenDialog: true, arguments: uniqueId);
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
                                Icon(Icons.wallet, size: 50),
                                SizedBox(height: 10),
                                Text('Recharge'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.roleId ==4,
                    child: Container(
                      height: 140,
                      width: 140,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => Payment(), fullscreenDialog: true, arguments: uniqueId);
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
                                Icon(Icons.wallet, size: 50),
                                SizedBox(height: 10),
                                Text('Pay'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 140,
                    width: 140,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => BalanceHistory(), fullscreenDialog: true, arguments: uniqueId);
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // Aligns content vertically
                            crossAxisAlignment: CrossAxisAlignment.center, // Aligns content horizontally
                            children: [
                              Icon(Icons.wallet, size: 50),
                              SizedBox(height: 10),
                              Text(
                                'Recharge History',
                                style: TextStyle(
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )

                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      )
    );
  }
}
