import 'package:eleven_crm/core/utils/route_constants.dart';
import 'package:flutter/material.dart';

import '../../features/main/presensation/screens/main_screen.dart';
import 'menu_constants.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(RouteSettings setting) => {
        RouteList.initial: (context) => MainScreen(menus: Menus.ordersMenu),
        RouteList.home: (context) => MainScreen(menus: Menus.ordersMenu),
        RouteList.configs: (context) => MainScreen(menus: Menus.configsMenu),
        RouteList.management: (context) =>
            MainScreen(menus: Menus.managementMenu),
        RouteList.orders: (context) => MainScreen(menus: Menus.ordersMenu),
        RouteList.product: (context) => MainScreen(menus: Menus.productMenu),
        // RouteList.logout: (context) => const LoginScreen(),
        // RouteList.login: (context) => const LoginScreen(),
        RouteList.statistic: (context) =>
            MainScreen(menus: Menus.statisticMenu),
      };
}
