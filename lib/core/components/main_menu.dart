import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/selection_button.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../utils/route_constants.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (previous, current) => current is LogoutSuccess,
      listener: (context, state) {
        // Navigator.pushNamed(context, RouteList.login);
      },
      builder: (context, state) {
        return SelectionButton(
          initialSelected: 0,
          data: [

            SelectionButtonData(
              key: RouteList.orders,
              activeIcon: Icons.add_shopping_cart_sharp,
              icon: Icons.add_shopping_cart_outlined,
              label: "orders".tr(),
              totalNotif: 0,
            ),


            SelectionButtonData(
              key: RouteList.configs,
              activeIcon: EvaIcons.settings,
              icon: EvaIcons.settingsOutline,
              label: "config".tr(),
              totalNotif: 0,
            ),
            SelectionButtonData(
              key: RouteList.crm,
              activeIcon: Icons.accessibility,
              icon: Icons.accessibility_outlined,
              label: "crm".tr(),
              totalNotif: 0,
            ),
            SelectionButtonData(
              key: RouteList.management,
              activeIcon: Icons.manage_accounts,
              icon: Icons.manage_accounts_outlined,
              label: "management".tr(),
              totalNotif: 0,
            ),

            SelectionButtonData(
              key: RouteList.product,
              activeIcon: Icons.assignment,
              icon: Icons.assessment_outlined,
              label: "product".tr(),
              totalNotif: 0,
            ),
            SelectionButtonData(
              key: RouteList.statistic,
              activeIcon: EvaIcons.barChart2,
              icon: EvaIcons.barChart2,
              label: "product".tr(),
              totalNotif: 0,
            ),
            SelectionButtonData(
              key: RouteList.logout,
              activeIcon: EvaIcons.logOut,
              icon: EvaIcons.logOutOutline,
              label: "signOut".tr(),
            ),
          ],
          onSelected: (index, selectionData) {
            if (selectionData.key == RouteList.logout) {
              context.read<LoginCubit>().logout();
            } else {
              // context.read<MenuCubit>().setMenu(index);
              Navigator.pushNamed(context, selectionData.key);
            }
          },
        );


        // return BlocBuilder<MenuCubit, int>(
        //   builder: (context, state) {
        //     return SelectionButton(
        //       initialSelected: state,
        //       data: [
        //
        //         SelectionButtonData(
        //           key: RouteList.orders,
        //           activeIcon: Icons.add_shopping_cart_sharp,
        //           icon: Icons.add_shopping_cart_outlined,
        //           label: "orders".tr(),
        //           totalNotif: 0,
        //         ),
        //
        //
        //         SelectionButtonData(
        //           key: RouteList.configs,
        //           activeIcon: EvaIcons.settings,
        //           icon: EvaIcons.settingsOutline,
        //           label: "config".tr(),
        //           totalNotif: 0,
        //         ),
        //         SelectionButtonData(
        //           key: RouteList.crm,
        //           activeIcon: Icons.accessibility,
        //           icon: Icons.accessibility_outlined,
        //           label: "crm".tr(),
        //           totalNotif: 0,
        //         ),
        //         SelectionButtonData(
        //           key: RouteList.management,
        //           activeIcon: Icons.manage_accounts,
        //           icon: Icons.manage_accounts_outlined,
        //           label: "management".tr(),
        //           totalNotif: 0,
        //         ),
        //
        //         SelectionButtonData(
        //           key: RouteList.product,
        //           activeIcon: Icons.assignment,
        //           icon: Icons.assessment_outlined,
        //           label: "product".tr(),
        //           totalNotif: 0,
        //         ),
        //         SelectionButtonData(
        //           key: RouteList.statistic,
        //           activeIcon: EvaIcons.barChart2,
        //           icon: EvaIcons.barChart2,
        //           label: "product".tr(),
        //           totalNotif: 0,
        //         ),
        //         SelectionButtonData(
        //           key: RouteList.logout,
        //           activeIcon: EvaIcons.logOut,
        //           icon: EvaIcons.logOutOutline,
        //           label: "signOut".tr(),
        //         ),
        //       ],
        //       onSelected: (index, selectionData) {
        //         if (selectionData.key == RouteList.logout) {
        //           context.read<LoginCubit>().logout();
        //         } else {
        //           context.read<MenuCubit>().setMenu(index);
        //           Navigator.pushNamed(context, selectionData.key);
        //         }
        //       },
        //     );
        //   },
        // );
      },
    );
  }
}

// if (selectionData.key == RouteList.home) {
//   context.read<MenuCubit>().setMenu(index);
//   Navigator.pushNamed(context, RouteList.home);
// } else if (selectionData.key == RouteList.settings) {
//   context.read<MenuCubit>().setMenu(index);
//   Navigator.pushNamed(context, RouteList.settings);
// } else if (selectionData.key == 'warehouse') {
//   context.read<MenuCubit>().setMenu(index);
//   Navigator.pushNamed(context, RouteList.orders);
// }

// class MainMenu extends StatelessWidget {
//   const MainMenu({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<LoginCubit, LoginState>(
//       listenWhen: (previous, current) => current is LogoutSuccess,
//       listener: (context, state) {
//         Navigator.pushNamed(context, RouteList.login);
//       },
//       builder: (context, state) {
//         return BlocBuilder<MenuCubit, int>(
//           builder: (context, state) {
//             return SelectionButton(
//               initialSelected: state,
//               data: [
//                 if (true)
//                   SelectionButtonData(
//                     key: RouteList.home,
//                     activeIcon: EvaIcons.home,
//                     icon: EvaIcons.homeOutline,
//                     label: "Главная".tr(),
//                   ),
//                 SelectionButtonData(
//                   key: RouteList.orders,
//                   activeIcon: EvaIcons.checkmarkCircle2,
//                   icon: EvaIcons.checkmarkCircle,
//                   label: "Заказы".tr(),
//                   totalNotif: 20,
//                 ),
//                 SelectionButtonData(
//                   key: RouteList.customers,
//                   activeIcon: EvaIcons.people,
//                   icon: EvaIcons.peopleOutline,
//                   label: "Клиенты".tr(),
//                   totalNotif: 100,
//                 ),
//                 SelectionButtonData(
//                   key: RouteList.employee,
//                   activeIcon: Icons.accessibility_new_rounded,
//                   icon: Icons.accessibility_outlined,
//                   label: "Сотрудники".tr(),
//                   totalNotif: 20,
//                 ),
//                 SelectionButtonData(
//                   key: RouteList.salary,
//                   activeIcon: Icons.account_balance_wallet_rounded,
//                   icon: Icons.account_balance_wallet_outlined,
//                   label: "Зар.платы".tr(),
//                   totalNotif: 20,
//                 ),
//                 SelectionButtonData(
//                   key: RouteList.expanses,
//                   activeIcon: Icons.monetization_on_rounded,
//                   icon: Icons.monetization_on_outlined,
//                   label: "Расходы".tr(),
//                   totalNotif: 20,
//                 ),
//                 SelectionButtonData(
//                   key: RouteList.warehouse,
//                   activeIcon: Icons.warehouse_rounded,
//                   icon: Icons.warehouse_outlined,
//                   label: "Склад".tr(),
//                   totalNotif: 20,
//                 ),
//                 SelectionButtonData(
//                   key: RouteList.settings,
//                   activeIcon: EvaIcons.settings,
//                   icon: EvaIcons.settingsOutline,
//                   label: "settings".tr(),
//                 ),
//                 SelectionButtonData(
//                   key: RouteList.logout,
//                   activeIcon: EvaIcons.logOut,
//                   icon: EvaIcons.logOutOutline,
//                   label: "signOut".tr(),
//                 ),
//               ],
//               onSelected: (index, selectionData) {
//                 if (selectionData.key == RouteList.logout) {
//                   context.read<LoginCubit>().logout();
//                 } else {
//                   context.read<MenuCubit>().setMenu(index);
//                   Navigator.pushNamed(context, selectionData.key);
//                 }

//                 // if (selectionData.key == RouteList.home) {
//                 //   context.read<MenuCubit>().setMenu(index);
//                 //   Navigator.pushNamed(context, RouteList.home);
//                 // } else if (selectionData.key == RouteList.settings) {
//                 //   context.read<MenuCubit>().setMenu(index);
//                 //   Navigator.pushNamed(context, RouteList.settings);
//                 // } else if (selectionData.key == 'warehouse') {
//                 //   context.read<MenuCubit>().setMenu(index);
//                 //   Navigator.pushNamed(context, RouteList.orders);
//                 // }
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }
