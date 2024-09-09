import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common_widgets/background_widget.dart';
import '../../models/report_model.dart';
import '../../server/apis.dart';
import '../family_member_list.dart';
import '../referal_members.dart';

class MyHome extends StatefulWidget {
  final int roleId;
  final int uniqueId;
  const MyHome({Key? key, required this.uniqueId, required this.roleId}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<AnalyticsReport>? _analyticsReportModel = [];
  final ApiServices apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
    getReportData(widget.uniqueId);
  }

  Future<void> getReportData(uniqueId) async {
    List<AnalyticsReport>? reportData =
    await apiServices.fetchReportlistData(uniqueId);
    setState(() {
      _analyticsReportModel = reportData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildGridMenu(widget.uniqueId),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildGridMenu(int uniqueId) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        if (widget.roleId == 4)
          _buildTile(
            icon: Icons.group_rounded,
            label: 'Referral Members',
            onTap: () {
              Get.to(() => ReferalMembers(),
                  fullscreenDialog: true, arguments: uniqueId);
            },
          ),

        if (widget.roleId == 4)
          _buildTile(
            icon: Icons.family_restroom,
            label: 'Family Member List',
            onTap: () {
              Get.to(() => FamilyMemberList(),
                  fullscreenDialog: true, arguments: uniqueId);
            },
          ),
      ],
    );
  }

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
