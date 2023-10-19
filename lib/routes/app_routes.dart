import 'package:get/get.dart';
import 'package:scanato/screens/dashboard.dart';
import 'package:scanato/screens/login.dart';
import 'package:scanato/screens/nav_pages/homepage.dart';

import '../screens/add_admin.dart';
import '../screens/register.dart';

class NyAppRouter {
  static final List<GetPage> routes = [
    GetPage(
      name: '/',
      page: () => const MyLogin(),
    ),
    GetPage(
      name: '/home',
      page: () => const HomePage(),
    ),
    GetPage(
      name: '/register',
      page: () => const MyRegister(),
    ),
    GetPage(
      name: '/dashboard',
      page: () => const Dashboard(),
    ),
    GetPage(
      name: '/admin',
      page: () => const AddAdmin(),
    ),
  ];
}
