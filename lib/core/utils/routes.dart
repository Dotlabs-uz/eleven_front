// import 'package:eleven_crm/core/utils/route_constants.dart';
// import 'package:eleven_crm/features/auth/presentation/pages/sign_in_screen.dart';
// import 'package:eleven_crm/features/main/presensation/screens/not_allow_screen.dart';
// import 'package:flutter/material.dart';
//
// import '../../features/main/presensation/screens/main_screen.dart';
// import 'menu_constants.dart';
//
// class Routes {
//   static Map<String, WidgetBuilder> getRoutes(RouteSettings setting, String? token) => {
//     RouteList.initial: (context) => MainScreen(menus: Menus.ordersMenu),
//     RouteList.home: (context) => MainScreen(menus: Menus.ordersMenu),
//     RouteList.configs: (context) => MainScreen(menus: Menus.configsMenu),
//     RouteList.management: (context) =>
//         MainScreen(menus: Menus.managementMenu),
//     RouteList.orders: (context) => MainScreen(menus: Menus.ordersMenu),
//     RouteList.product: (context) => MainScreen(menus: Menus.productMenu),
//     RouteList.settings: (context) => MainScreen(menus: Menus.configsMenu),
//     RouteList.logout: (context) => const SignInScreen(),
//     RouteList.login: (context) => const SignInScreen(),
//   };
//   // static Map<String, WidgetBuilder> getRoutes(
//   //     RouteSettings setting, String? token) {
//   //   return {
//   //     RouteList.initial: (context) => _routeBuilder(
//   //           context: context,
//   //           token: token,
//   //           screen: MainScreen(menus: Menus.ordersMenu),
//   //         ),
//   //     RouteList.home: (context) => _routeBuilder(
//   //           context: context,
//   //           token: token,
//   //           screen: MainScreen(menus: Menus.ordersMenu),
//   //         ),
//   //     RouteList.configs: (context) => _routeBuilder(
//   //           context: context,
//   //           token: token,
//   //           screen: MainScreen(menus: Menus.configsMenu),
//   //         ),
//   //     RouteList.management: (context) => _routeBuilder(
//   //           context: context,
//   //           token: token,
//   //           screen: MainScreen(menus: Menus.managementMenu),
//   //         ),
//   //     RouteList.orders: (context) => _routeBuilder(
//   //           context: context,
//   //           token: token,
//   //           screen: MainScreen(menus: Menus.ordersMenu),
//   //         ),
//   //     RouteList.product: (context) => _routeBuilder(
//   //           context: context,
//   //           token: token,
//   //           screen: MainScreen(menus: Menus.productMenu),
//   //         ),
//   //     RouteList.settings: (context) => _routeBuilder(
//   //           context: context,
//   //           token: token,
//   //           screen: MainScreen(menus: Menus.configsMenu),
//   //         ),
//   //     RouteList.logout: (context) => _routeBuilder(
//   //           context: context,
//   //           token: token,
//   //           screen: const SignInScreen(),
//   //           placeHolderScreen: const SignInScreen(),
//   //         ),
//   //     RouteList.login: (context) => _routeBuilder(
//   //           context: context,
//   //           token: token,
//   //           screen: const SignInScreen(),
//   //           placeHolderScreen: const SignInScreen(),
//   //         ),
//   //   };
//   // }
// }
//
// Widget _routeBuilder({
//   required BuildContext context,
//   required String? token,
//   required Widget screen,
//   Widget placeHolderScreen = const NotAllowScreen(),
// }) {
//   bool condition = token == null || token.isEmpty;
//
//   debugPrint(" Condition $token $condition");
//   return condition == true ? placeHolderScreen : screen;
// }
