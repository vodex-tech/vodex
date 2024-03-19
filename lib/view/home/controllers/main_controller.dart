import 'package:admin/admin.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logic_study/view/auth/auth/controller.dart';
import 'package:logic_study/view/home/all_courses_page.dart';
import 'package:logic_study/view/home/home_page.dart';
import 'package:logic_study/view/home/my_account/account_page.dart';

class MainController extends GetxController {
  final selectedIndex = 0.obs;

  final bottomNavBarItems = [
    NavigationItem(
      title: 'الرئيسية',
      icon: 'home',
      page: const HomePage(),
    ),
    NavigationItem(
      title: 'كورساتي',
      icon: 'book',
      page: const AllCoursesPage(),
    ),
    NavigationItem(
      title: 'الحساب',
      icon: 'profile',
      page: const AccountPage(),
    ),
    if(Get.find<Auth>().isAdmin) NavigationItem(
      title: 'Admin',
      icon: 'user-octagon',
      page: const AdminPage(),
    ),
  ];
}

class NavigationItem {
  final String title;
  final String icon;
  final Widget page;

  NavigationItem({
    required this.title,
    required this.icon,
    required this.page,
  });
}
