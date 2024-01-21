import 'dart:convert';
import 'dart:developer';

import 'package:eleven_crm/core/components/page_not_allowed_widget.dart';
import 'package:eleven_crm/core/utils/route_constants.dart';
import 'package:eleven_crm/features/main/presensation/screens/page_not_found.dart';
import 'package:eleven_crm/features/management/presentation/screens/barber_profile_screen.dart';
import 'package:eleven_crm/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/sign_in_screen.dart';
import '../../features/main/presensation/screens/home_screen.dart';
import '../../features/main/presensation/screens/main_screen.dart';
import '../../features/management/data/model/barber_model.dart';
import '../../features/management/domain/entity/barber_entity.dart';
import '../../features/management/domain/entity/employee_entity.dart';
import '../../features/management/presentation/cubit/barber/barber_cubit.dart';
import '../../features/management/presentation/screens/barber_screen.dart';
import '../../features/management/presentation/screens/customer_screen.dart';
import '../../features/management/presentation/screens/employee_profile_screen.dart';
import '../../features/management/presentation/screens/employee_schedule_screen.dart';
import '../../features/management/presentation/screens/employee_screen.dart';
import '../../features/management/presentation/screens/manager_screen.dart';
import '../../features/products/presensation/screens/service_product_category_screen.dart';
import '../../features/products/presensation/screens/service_products_screen.dart';

class AppNavigation {
  AppNavigation._();

  static String initial = RouteList.home;

  // Private navigators
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome = GlobalKey<NavigatorState>(
    debugLabel: 'home',
  );
  static final _shellNavigatorManagement = GlobalKey<NavigatorState>(
    debugLabel: 'management',
  );
  static final _shellNavigatorProduct = GlobalKey<NavigatorState>(
    debugLabel: 'product',
  );
  static final _shellNavigatorConfig = GlobalKey<NavigatorState>(
    debugLabel: 'config',
  );

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: initial,
    errorPageBuilder: (context, state) {
      return MaterialPage(child: PageNotFound(context: context));
    },
    debugLogDiagnostics: true,
    routerNeglect: true,
    redirect: (context, state) async {
      final token = await getSessionToken();

      if (token == null) {
        return RouteList.login;
      }
      return state.path;
    },
    navigatorKey: _rootNavigatorKey,
    routes: [
      /// MainWrapper
      GoRoute(
        path: RouteList.initial,
        builder: (BuildContext context, GoRouterState state) =>
            const SignInScreen(),
      ),

      GoRoute(
        path: RouteList.login,
        builder: (BuildContext context, GoRouterState state) =>
            const SignInScreen(),
      ),

      GoRoute(
        path: RouteList.editBarber,
        builder: (BuildContext context, GoRouterState state) {
          final barberId = state.pathParameters['id']!;
          return BarberProfileScreen(
            barberId: barberId,
            barberEntity: state.extra as BarberEntity,
          );
        },
      ),
      GoRoute(
        path: RouteList.editEmployee,
        builder: (BuildContext context, GoRouterState state) {
          return EmployeeProfileScreen(
            employeeEntity: state.extra as EmployeeEntity,
          );
        },
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: RouteList.home,
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeScreen(),
                routes: [
                  GoRoute(
                    path: RouteList.orders,
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const HomeScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                  GoRoute(
                    path: RouteList.employeeSchedule,
                    pageBuilder: (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const EmployeeScheduleScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorManagement,
            routes: <RouteBase>[
              GoRoute(
                path: RouteList.management,
                builder: (BuildContext context, GoRouterState state) =>
                    const CustomerScreen(),
                routes: [
                  GoRoute(
                    path: RouteList.customers,
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const CustomerScreen(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                  GoRoute(
                    path: RouteList.managers,
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const ManagerScreen(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                  GoRoute(
                    path: RouteList.employees,
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const EmployeeScreen(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                  GoRoute(
                    path: RouteList.barbers,
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const BarberScreen(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProduct,
            routes: <RouteBase>[
              GoRoute(
                path: RouteList.products,
                builder: (BuildContext context, GoRouterState state) =>
                    const ServiceProductsScreen(),
                routes: [
                  GoRoute(
                    path: RouteList.services,
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const ServiceProductsScreen(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                  GoRoute(
                    path: RouteList.servicesCategory,
                    pageBuilder: (context, state) {
                      return CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const ServiceProductCategoryScreen(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) =>
                            FadeTransition(opacity: animation, child: child),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
