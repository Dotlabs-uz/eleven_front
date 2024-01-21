import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../components/floating_menu_widget.dart';

class RouteList {
  RouteList._();

  // static const String arrival = '/arrival';
  static const String configs = '/configs';
  static const String crm = '/crm';
  static const String product = '/product';
  static const String homeScreen = '/home_screen';
  static const String settings = '/settings';

  // Screen routes

  static const String orders = 'orders';
  static const String employeeSchedule = 'employeeSchedule';
  static const String customers = 'customers';
  static const String managers = 'managers';
  static const String employees = 'employees';
  static const String barbers = 'barbers';
  static const String services = 'services';
  static const String servicesCategory = 'servicesCategory';
  static const String profile = 'profile';

  //  Base Routes

  static const String initial = '/';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String home = '/home';
  static const String management = '/management';
  static const String managementBarber = '$management/$barbers';
  static const String products = '/products';


  static const String editBarber = '/$barbers/:id';
  static const String editEmployee = '/$employees/:id';

  static String edit(String route, String id) {
    return "/$route/:$id";
  }
}

final listEntityPages = [
  FloatingMenuEntity(
    key: RouteList.home,
    icon: Icons.home_filled,
    title: "homeScreen".tr(),
    index: 0,
  ),
  FloatingMenuEntity(
    key: RouteList.management,
    icon: Icons.manage_accounts_outlined,
    title: "management".tr(),
    index: 1,
  ),
  FloatingMenuEntity(
    key: RouteList.product,
    icon: Icons.assessment_outlined,
    title: "product".tr(),
    index: 2,
  ),
  FloatingMenuEntity(
    key: RouteList.configs,
    icon: EvaIcons.settingsOutline,
    title: "config".tr(),
    index: 3,
  ),
  FloatingMenuEntity(
    key: RouteList.settings,
    icon: EvaIcons.barChart2,
    title: "settings".tr(),
    index: 4,
  ),
  FloatingMenuEntity(
    key: RouteList.logout,
    icon: EvaIcons.logOutOutline,
    title: "signOut".tr(),
    index: 5,
  ),
];
