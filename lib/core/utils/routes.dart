import 'package:eleven_crm/core/utils/route_constants.dart';
import 'package:eleven_crm/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:eleven_crm/features/main/presensation/screens/not_allow_screen.dart';
import 'package:eleven_crm/features/management/presentation/screens/barber_profile_screen.dart';
import 'package:flutter/material.dart';

import '../../features/main/presensation/screens/main_screen.dart';
import '../../features/management/domain/entity/barber_entity.dart';
import 'menu_constants.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(RouteSettings setting, String? token) => {
    RouteList.initial: (context) => MainScreen(menus: Menus.ordersMenu),
    RouteList.home: (context) => MainScreen(menus: Menus.ordersMenu),
    RouteList.configs: (context) => MainScreen(menus: Menus.configsMenu),
    RouteList.management: (context) =>
        MainScreen(menus: Menus.managementMenu),
    RouteList.orders: (context) => MainScreen(menus: Menus.ordersMenu),
    RouteList.product: (context) => MainScreen(menus: Menus.productMenu),
    RouteList.settings: (context) => MainScreen(menus: Menus.configsMenu),
    RouteList.logout: (context) => const SignInScreen(),
    RouteList.login: (context) => const SignInScreen(),
  };

}

Widget _routeBuilder({
  required BuildContext context,
  required String? token,
  required Widget screen,
  Widget placeHolderScreen = const NotAllowScreen(),
}) {
  final condition = token == null || token.isEmpty;

  print(" Condition $token $condition");
  return condition == true ? placeHolderScreen : screen;
}
