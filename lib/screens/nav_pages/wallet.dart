import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scanato/screens/pay.dart';
import '../../common_widgets/background_widget.dart';
import '../../server/apis.dart';
import '../balance_history.dart';
import '../recharge.dart';
import '../referal_members.dart';

class Wallet extends StatefulWidget {
  final int roleId;
  final int uniqueId;
  const Wallet({Key? key, required this.uniqueId, required this.roleId})
      : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String _version = '';
  ApiServices apiServices = ApiServices();
  double? balance;

  @override
  void initState() {
    super.initState();
    _fetchVersion();
    fetchBalance();
  }

  Future<void> _fetchVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
    _showVersionSnackbar();
  }

  Future<void> fetchBalance() async {
    try {
      final balanceData = await apiServices.fetchBalanceData(widget.uniqueId);
      setState(() {
        balance = balanceData;
        print('balance==============%$balance');
      });
    } catch (e) {
      print('Error fetching balance: $e');
    }
  }

  void _showVersionSnackbar() {
    final snackBar = SnackBar(
      content: Text('App Version: $_version'),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final uniqueId = widget.uniqueId;
    print('uniqueId=====on wallet =======$uniqueId');

    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                balance != null
                    ? _buildBalanceCard()
                    : const CircularProgressIndicator(),
                const SizedBox(height: 20),
                _buildGridMenu(uniqueId),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Balance Display Card with improved design
  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Balance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '₹${balance!.toStringAsFixed(2)}', // Using ₹ for Rupees
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // Improved Grid Menu
  Widget _buildGridMenu(int uniqueId) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        if (widget.roleId == 1 || widget.roleId == 2)
          _buildTile(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Recharge',
            onTap: () {
              Get.to(() => Recharge(roleId: widget.roleId),
                  fullscreenDialog: true, arguments: uniqueId);
            },
          ),
        if (widget.roleId == 4)
          _buildTile(
            icon: Icons.payment_rounded,
            label: 'Pay',
            onTap: () {
              Get.to(() => Payment(),
                  fullscreenDialog: true, arguments: uniqueId);
            },
          ),
        _buildTile(
          icon: Icons.history_rounded,
          label: 'Recharge History',
          onTap: () {
            Get.to(() => BalanceHistory(),
                fullscreenDialog: true, arguments: uniqueId);
          },
        ),
      ],
    );
  }

  // Enhanced Tile with color and styling
  Widget _buildTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.purple.shade100, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.purple.shade600),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
