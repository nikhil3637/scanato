import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanato/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/', // Set the initial route
      getPages: NyAppRouter.routes, // Add the routes from app_routes.dart
      debugShowCheckedModeBanner: false,
      title: 'Scanato',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
    );
  }
}
