import 'package:flutter/material.dart';

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
      text: 'customer_orders',
      page: Container(),
    ),
    SubMenu(
      icon: const Icon(Icons.category),
      text: 'order_payments',
      page: Container(),
    ),
    SubMenu(
      icon: const Icon(Icons.category),
      text: 'blind_order_items',
      page: Container(),
    ),
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
      page: Container(),

    ),

  ];

  static List<SubMenu> productMenu = [
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'blinds_type',
      page: Container(),
    ),

  ];

  static List<SubMenu> configsMenu = [
    SubMenu(
      icon: const Icon(Icons.category),
      text: 'profile',
      page: Container(),
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
