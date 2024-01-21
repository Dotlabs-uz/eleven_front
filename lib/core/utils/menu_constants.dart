import 'package:eleven_crm/core/utils/route_constants.dart';
import 'package:eleven_crm/features/management/presentation/screens/employee_schedule_screen.dart';
import 'package:flutter/material.dart';


class SubMenu {
  final String text;
  final Icon icon;
  final String route;
  final String rootRoute;

  SubMenu({required this.text, required this.icon, required this.route,required this.rootRoute});
}

class Menus {
  Menus._();

  static List<SubMenu> ordersMenu = [
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'homeScreen',
      // page: const SizedBox(),
      route: RouteList.orders,
      rootRoute: RouteList.home,
    ),
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'employee_schedule',
      route: RouteList.employeeSchedule,
      rootRoute: RouteList.home,

    ),
  ];

  static List<SubMenu> managementMenu = [
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'customer',
      route: RouteList.customers,
      rootRoute: RouteList.management,

    ),
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'managers',
      route: RouteList.managers,
      rootRoute: RouteList.management,

    ),
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'employee',
      route: RouteList.employees,
      rootRoute: RouteList.management,

    ),
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'barbers',
      route: RouteList.barbers,
      rootRoute: RouteList.management,

    ),
  ];

  static List<SubMenu> productMenu = [
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'services',
      route: RouteList.services,
      rootRoute: RouteList.products,


    ),
    SubMenu(
      icon: const Icon(Icons.display_settings_rounded),
      text: 'service_product_category',
      route: RouteList.servicesCategory,
      rootRoute: RouteList.products,

    ),
  ];

  static List<SubMenu> configsMenu = [
    SubMenu(
      icon: const Icon(Icons.category),
      text: 'profile',
      route: RouteList.profile,
      rootRoute: RouteList.configs,

    ),
  ];

  // static List<SubMenu> statisticMenu = [
  //   SubMenu(
  //     icon: const Icon(Icons.display_settings_rounded),
  //     text: 'statisticSalary',
  //     page: Container(),
  //   ),
  // ];
}
