import 'package:eleven_crm/core/utils/route_constants.dart';
import 'package:flutter/material.dart';

import '../../features/main/presensation/screens/main_screen.dart';
import 'menu_constants.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(RouteSettings setting) => {
        RouteList.initial: (context) => DefaultScreen(menus: Menus.ordersMenu),
        RouteList.home: (context) => DefaultScreen(menus: Menus.ordersMenu),
        RouteList.configs: (context) => DefaultScreen(menus: Menus.configsMenu),
        RouteList.management: (context) =>
            DefaultScreen(menus: Menus.managementMenu),
        RouteList.orders: (context) => DefaultScreen(menus: Menus.ordersMenu),
        RouteList.product: (context) => DefaultScreen(menus: Menus.productMenu),
        // RouteList.logout: (context) => const LoginScreen(),
        // RouteList.login: (context) => const LoginScreen(),
        RouteList.statistic: (context) =>
            DefaultScreen(menus: Menus.statisticMenu),
      };
}
