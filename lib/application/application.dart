import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/auth/presentation/cubit/login_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/avatar/avatar_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/data_form/data_form_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/home_screen_form/home_screen_order_form_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/order/order_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/order_filter_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/top_menu_cubit/top_menu_cubit.dart';
import 'package:eleven_crm/features/management/presentation/cubit/customer/customer_cubit.dart';
import 'package:eleven_crm/features/management/presentation/provider/cross_in_employee_schedule_provider.dart';
import 'package:eleven_crm/features/products/presensation/cubit/service_product_category/service_product_category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/route_constants.dart';
import '../core/utils/routes.dart';
import '../features/main/presensation/cubit/current_user/current_user_cubit.dart';
import '../features/main/presensation/cubit/locale/locale_cubit.dart';
import '../features/main/presensation/cubit/menu/menu_cubit.dart';
import '../features/main/presensation/cubit/show_client_orders_history/show_client_orders_history_cubit.dart';
import '../features/main/presensation/cubit/show_order_history/show_order_history_cubit.dart';
import '../features/main/presensation/cubit/show_select_services/show_select_services_cubit.dart';
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
  late DataFormCubit _dataFormCubit;
  late ServiceProductCategoryCubit _serviceProductCategoryCubit;
  late OrderCubit _orderCubit;
  late CurrentUserCubit currentUserCubit;
  late ShowSelectServicesCubit showSelectServicesCubit;
  late ShowClientOrdersHistoryCubit showClientOrdersHistoryCubit;
  late ShowOrderHistoryCubit showOrderHistoryCubit;
  late HomeScreenOrderFormCubit homeScreenOrderFormCubit;
  late OrderFilterCubit orderFilterCubit;
  late AvatarCubit avatarCubit;
  late CustomerCubit customerCubit;
  late CrossInEmployeeScheduleProvider crossInEmployeeScheduleProvider;
  late LocaleCubit   localeCubit;

  @override
  void initState() {
    _loginCubit = locator();
    _menuCubit = locator();
    _topMenuCubit = locator();
    _dataFormCubit = locator();
    _serviceProductCategoryCubit = locator();
    homeScreenOrderFormCubit = locator();
    _orderCubit = locator();
    currentUserCubit = locator();
    showSelectServicesCubit = locator();
    orderFilterCubit = locator();
    avatarCubit = locator();
    customerCubit = locator();
    showOrderHistoryCubit = locator();
    crossInEmployeeScheduleProvider = locator();
    showClientOrdersHistoryCubit = locator();
    localeCubit = locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ChangeNotifierProvider.value(value: crossInEmployeeScheduleProvider),
        BlocProvider.value(value: _loginCubit),
        BlocProvider.value(value: _menuCubit),
        BlocProvider.value(value: _topMenuCubit),
        BlocProvider.value(value: _dataFormCubit),
        BlocProvider.value(value: _serviceProductCategoryCubit),
        BlocProvider.value(value: _orderCubit),
        BlocProvider.value(value: currentUserCubit),
        BlocProvider.value(value: showSelectServicesCubit),
        BlocProvider.value(value: homeScreenOrderFormCubit),
        BlocProvider.value(value: orderFilterCubit),
        BlocProvider.value(value: avatarCubit),
        BlocProvider.value(value: customerCubit),
        BlocProvider.value(value: showOrderHistoryCubit),
        BlocProvider.value(value: showClientOrdersHistoryCubit),
        BlocProvider.value(value: localeCubit),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Eleven CRM',
        theme: ThemeData(
          primaryColor: Colors.red,
          scaffoldBackgroundColor: AppColors.scaffoldColor,
          // backgroundColor: Colors.white,

          iconTheme: const IconThemeData(color: Colors.blue),
          appBarTheme:   const AppBarTheme(
            // color: AppColor.menuBgColor,
            backgroundColor: AppColors.sideMenu,
          ),
        ),
        // scrollBehavior: CustomScrollBehaviour(),
        initialRoute: RouteList.login,
        // home: const LoginScreen(),
        onGenerateRoute: (RouteSettings settings) {
          final Map<String, WidgetBuilder> routes = Routes.getRoutes(settings);
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
