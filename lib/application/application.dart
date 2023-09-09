import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/auth/presentation/cubit/login_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/top_menu_cubit/top_menu_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/route_constants.dart';
import '../core/utils/routes.dart';
import '../features/main/presensation/cubit/menu/menu_cubit.dart';
import '../features/main/presensation/widget/fade_page_route_builder.dart';
import '../get_it/locator.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  late LoginCubit _loginCubit;
  late MenuCubit _menuCubit;
  late TopMenuCubit _topMenuCubit;
  @override
  void initState() {
    _loginCubit = locator();
    _menuCubit = locator();
    _topMenuCubit = locator();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _loginCubit),
        BlocProvider.value(value: _menuCubit),
        BlocProvider.value(value: _topMenuCubit),


      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: const Locale("ru"),
        title: 'Eleven CRM',
        theme: ThemeData(
          primaryColor: Colors.red,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.blue),
          appBarTheme: const AppBarTheme(
            // color: AppColor.menuBgColor,

            backgroundColor: AppColors.background,
          ),
        ),
        // scrollBehavior: CustomScrollBehaviour(),
        initialRoute: RouteList.home, // TODO Change to login
        // home: const LoginScreen(),
        onGenerateRoute: (RouteSettings settings) {
          final Map<String, WidgetBuilder> routes =
          Routes.getRoutes(settings);
          // final WidgetBuilder builder;
          // if (settings.name != null) {
          //   builder = routes[settings.name]!;
          // } else {
          //   builder = routes["login"]!;
          // }

          return FadePageRouteBuilder(
            builder: routes[settings.name]!,
            settings: settings,
          );
        },
      ),
    );

  }
}

