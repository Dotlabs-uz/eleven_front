import 'package:eleven_crm/features/management/presentation/screens/employee_schedule_screen.dart';
import 'package:flutter/material.dart';

import '../../features/main/presensation/screens/home_screen.dart';
import '../../features/main/presensation/screens/profile_screen.dart';
import '../../features/management/presentation/screens/barber_screen.dart';
import '../../features/management/presentation/screens/customer_screen.dart';
import '../../features/management/presentation/screens/employee_screen.dart';
import '../../features/management/presentation/screens/manager_screen.dart';
import '../../features/products/presensation/screens/service_product_category_screen.dart';
import '../../features/products/presensation/screens/service_products_screen.dart';

class SubMenu {
  final String text;
  final Icon icon;
  final Widget page;

  SubMenu({required this.text, required this.icon, required this.page});
}

class Menus {
  Menus._();

  static List<SubMenu> ordersMenu = [
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'homeScreen',
      // page: const SizedBox(),
      page: const HomeScreen(),
    ),
    // SubMenu(
    //   icon: const Icon(Icons.category),
    //   text: 'order_payments',
    //   page: Container(),
    // ),
    // SubMenu(
    //   icon: const Icon(Icons.category),
    //   text: 'blind_order_items',
    //   page: Container(),
    // ),
  ];

  // static List<SubMenu> crmMenu = [
  //   SubMenu(
  //     icon: const Icon(Icons.display_settings_rounded),
  //     text: 'customer',
  //     page: const CustomerPage(),
  //   ),
  // ];

  static List<SubMenu> managementMenu = [
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'customer',
      page: const CustomerScreen(),
    ), SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'managers',
      page: const ManagerScreen(),
    ),
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'employee',
      page: const EmployeeScreen(),
    ),
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'employee_schedule',
      page: const EmployeeScheduleScreen(),
    ),
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'barbers',
      page: const BarberScreen(),
    ),
  ];

  static List<SubMenu> productMenu = [
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'services',
      page: const ServiceProductsScreen(),
    ),
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'service_product_category',
      page: const ServiceProductCategoryScreen(),
    ),
  ];

  static List<SubMenu> configsMenu = [
    SubMenu(
      icon: const Icon(Icons.category),
      text: 'profile',
      page: const ProfileScreen(),
    ),
  ];

  static List<SubMenu> statisticMenu = [
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'statisticSalary',
      page: Container(),
    ),
  ];
}
