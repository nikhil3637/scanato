import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scanato/screens/admin_list.dart';
import 'package:scanato/server/apis.dart';


class AddAdmin extends StatefulWidget {
  const AddAdmin({Key? key}) : super(key: key);

  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiServices apiServices = ApiServices();


  @override
  Widget build(BuildContext context) {
    final uniqueId = Get.arguments;
    print('uniqueId received on admin page=====$uniqueId');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/robologo.jpg',
          height: 100,
          width: 100,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: nameController,
                labelText: 'Name',
                prefixIcon: Icons.person,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: emailController,
                labelText: 'Email',
                prefixIcon: Icons.email,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: mobileController,
                labelText: 'Mobile',
                prefixIcon: Icons.phone,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: passwordController,
                labelText: 'Password',
                prefixIcon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  apiServices.addAdmin(nameController.text, emailController.text, mobileController.text, passwordController.text,uniqueId).then((success) {
                    if (success) {
                      // Clear text fields on success
                      nameController.clear();
                      emailController.clear();
                      mobileController.clear();
                      passwordController.clear();
                    }
                  });
                },
                child: Text('Add Admin'),
              ),
              if (apiServices.isLoading.value)
                Center(
                  child: CircularProgressIndicator(),
                ),
              SizedBox(height: 40,),
              GestureDetector(
                onTap: () {
                  Get.to( () => AdminList(),fullscreenDialog: true,);
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
                        Text('Admin List'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? prefixIcon,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),

      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
