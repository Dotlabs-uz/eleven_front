import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/search_field.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/components/drawer_widget.dart';
import '../../../../core/components/floating_menu_widget.dart';
import '../../../../core/components/responsive_builder.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../core/utils/menu_constants.dart';
import '../../../../core/utils/route_constants.dart';
import '../../../auth/presentation/cubit/login_cubit.dart';
import '../../domain/entity/top_menu_entity.dart';
import '../cubit/menu/menu_cubit.dart';
import '../cubit/top_menu_cubit/top_menu_cubit.dart';
import '../widget/my_icon_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.menus}) : super(key: key);
  final List<SubMenu> menus;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  String version = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: ResponsiveBuilder.isDesktop(context) &&
              ResponsiveBuilder.isTablet(context)
          ? null
          : DrawerWidget(
              onChanged: (value) {
                if (value.key == RouteList.logout) {
                  Dialogs.exitDialog(
                    context: context,
                    onExit: () {
                      BlocProvider.of<LoginCubit>(context).logout();
                    },
                  );
                } else {
                  BlocProvider.of<MenuCubit>(context).setMenu(value.index);
                  Navigator.pushNamed(context, value.key);
                }
              },
              version: version,
            ),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          Navigator.pushNamed(context, RouteList.login);
        },
        child: SafeArea(
          child: ResponsiveBuilder(
            mobileBuilder: (context, constraints) {
              return ContentWidget(
                menus: widget.menus,
                openDrawer: () {},
              );
            },
            tabletBuilder: (context, constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: constraints.maxWidth > 800 ? 12 : 10,
                    child: ContentWidget(
                      menus: widget.menus,
                      openDrawer: () {},
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const VerticalDivider(),
                  ),
                ],
              );
            },
            desktopBuilder: (context, constraints) {
              return Container(
                color: AppColors.mainTextColor,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SideMenuWidget(),
                    // Flexible(
                    //   flex: constraints.maxWidth > 1350 ? 3 : 4,
                    //   child: SingleChildScrollView(
                    //     controller: ScrollController(),
                    //     child: _buildSidebar(context),
                    //   ),
                    // ),
                    Expanded(
                      child: ContentWidget(
                        menus: widget.menus,
                        openDrawer: () {},
                      ),
                    ),
                    // Flexible(
                    //   flex: constraints.maxWidth > 1350 ? 14 : 11,
                    //   child: ContentWidget(
                    //     menus: widget.menus,
                    //     openDrawer: controller.openDrawer,
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SideMenuWidget extends StatelessWidget {
  const SideMenuWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteList.login,
          (route) => false,
        );
      },
      child: BlocBuilder<MenuCubit, int>(
        builder: (context, state) {
          return FloatingMenuWidget(
            listEntity: [
              FloatingMenuEntity(
                key: RouteList.home,
                icon: Icons.home_filled,
                title: "homeScreen".tr(),
                index: 0,
              ),
              // FloatingMenuEntity(
              //   key: RouteList.crm,
              //   icon: Icons.accessibility_outlined,
              //   title: "crm".tr(),
              //   index: 2,
              // ),
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
              // FloatingMenuEntity(
              //   key: RouteList.configs,
              //   icon: EvaIcons.settingsOutline,
              //   title: "config".tr(),
              //   index: 3,
              // ),
              // FloatingMenuEntity(
              //   key: RouteList.settings,
              //   icon: EvaIcons.barChart2,
              //   title: "settings".tr(),
              //   index: 4,
              // ),
              // FloatingMenuEntity(
              //   key: RouteList.logout,
              //   icon: EvaIcons.logOutOutline,
              //   title: "signOut".tr(),
              //   index: 5,
              // ),
            ],
            onProfileTap: () {
              BlocProvider.of<MenuCubit>(context).setMenu(3); // Profile
              Navigator.pushNamed(context, RouteList.configs);
            },
            onChanged: (value) {
              if (value.key == RouteList.logout) {
              } else {
                BlocProvider.of<MenuCubit>(context).setMenu(value.index);
                Navigator.pushNamed(context, value.key);
              }
            },
            selectedIndex: state,
          );
        },
      ),
    );
  }
}

class ContentWidget extends StatefulWidget {
  const ContentWidget({Key? key, required this.openDrawer, required this.menus})
      : super(key: key);
  final List<SubMenu> menus;
  final void Function() openDrawer;

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  late SubMenu page;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    page = widget.menus.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topMenu(),
          _searchAndActionsMenu(),
          Expanded(
            child: page.page,
          ),
        ],
      ),
    );
  }

  _topMenu() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            widget.menus.length,
            (index) => InkWell(
              onTap: () => setState(() => page = widget.menus[index]),
              child: Ink(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    border: page == widget.menus[index]
                        ? Border(
                            bottom: BorderSide(
                              width: 1.0,
                              color: Colors.lightBlue.shade900,
                            ),
                          )
                        : null,
                  ),
                  child: Container(
                    height: 35,
                    margin: const EdgeInsets.only(
                      left: 12,
                      top: 4,
                      right: 12,
                      bottom: 0,
                    ),
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      widget.menus[index].text.tr().toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _searchAndActionsMenu() {
    final TextEditingController textEditingController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: BlocBuilder<TopMenuCubit, TopMenuEntity>(
        builder: (context, data) {
          if (data.iconList.isEmpty) {
            return const SizedBox();
          } else {
            textEditingController.clear();
          }
          return SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child:data.enableSearch ? SearchField(
                    onSearch: data.searchCubit == null
                        ? null
                        : (value) {
                            data.searchCubit.load(value);
                          },
                  ): const SizedBox.shrink(),
                ),
                ...data.iconList,
              ],
            ),
          );
        },
      ),
    );
  }

// Row(
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// Expanded(
// child: Row(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// if (!ResponsiveBuilder.isDesktop(context))
// IconButton(
// onPressed: widget.openDrawer,
// enableFeedback: true,
// icon:
// const Icon(Icons.menu, color: AppColor.menuBgColor),
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: BlocBuilder<TopMenuCubit, List<MyIconButton>>(
// builder: (context, listWidget) {
// if (listWidget.isEmpty) return const SizedBox();
// // return IconButtonBar(
// //   childSize: const Size(48, 48),
// //   children: listWidget,
// // );
// return Row(
// crossAxisAlignment: CrossAxisAlignment.center,
// children: listWidget
//     .map(
// (e) => Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// // RotatedBox(
// //   quarterTurns: 2,
// //   child: SvgPicture.asset(
// //     Assets.tChevronLeftIcon,
// //   ),
// // ),
//
// // const Padding(
// //   padding: EdgeInsets.symmetric(
// //       horizontal: 8.0),
// //   child: Text(
// //     "|",
// //     style: TextStyle(
// //       fontSize: 16,
// //       color: AppColor.menuBgColor,
// //       fontWeight: FontWeight.w700,
// //     ),
// //   ),
// // ),
//
// const SizedBox(width: 5),
// e,
// ],
// ),
// )
//     .toList(),
// );
// },
// ),
// ),
// const Padding(
// padding: EdgeInsets.symmetric(horizontal: 8.0),
// child: Text(
// "|",
// style: TextStyle(
// fontSize: 16,
// color: AppColor.menuBgColor,
// fontWeight: FontWeight.w700,
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.only(left: 10),
// child: Text(
// page.text.tr().toUpperCase(),
// style: GoogleFonts.nunito(
// color: const Color(0xff0c2556),
// fontSize: 14,
// height: 1.8,
// fontWeight: FontWeight.w800,
// ),
// ),
// ),
// ],
// ),
// ),
// // Expanded(
// //   child: IconButtonBar(
// //     childSize: const Size(100, 48),
// //     children: List.generate(
// //       widget.menus.length,
// //       (index) => InkWell(
// //         onTap: () => setState(() => page = widget.menus[index]),
// //         child: Ink(
// //           child: AnimatedContainer(
// //             duration: const Duration(milliseconds: 200),
// //             decoration: BoxDecoration(
// //               border: page == widget.menus[index]
// //                   ? Border(
// //                       bottom: BorderSide(
// //                         width: 2.0,
// //                         color: Colors.lightBlue.shade900,
// //                       ),
// //                     )
// //                   : null,
// //             ),
// //             child: Padding(
// //               padding: const EdgeInsets.all(12.0),
// //               child: Text(
// //                 widget.menus[index].text.tr().toUpperCase(),
// //                 style: const TextStyle(
// //                   color: Colors.black,
// //                   fontSize: 14,
// //                   fontFamily: "Nunito",
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     ),
// //   ),
// // ),
// PopupMenuButton<SubMenu>(
// padding: const EdgeInsets.only(right: 15),
// icon: const Icon(
// Icons.more_horiz_rounded,
// color: AppColor.menuBgColor,
// ),
// initialValue: page,
// // Callback that sets the selected popup menu item.
// onSelected: (SubMenu item) {
// setState(() => page = item);
// },
// itemBuilder: (BuildContext context) =>
// <PopupMenuEntry<SubMenu>>[
// ...widget.menus.map((data) {
// var title = data.text.tr();
// return PopupMenuItem<SubMenu>(
// value: data,
// child: Text(
// '${title[0].toUpperCase()}${title.substring(1)}',
// style: GoogleFonts.nunito(
// color: Colors.black,
// fontWeight: FontWeight.w700,
// fontSize: 14,
// ),
// ),
// );
// })
// ],
// ),
//
// //////
// // DropdownButton<SubMenu>(
// //   icon: const Icon(Icons.menu),
// //   underline: const SizedBox(),
// //   hint: const SizedBox(),
// //   value: page,
// //   // selectedItemBuilder: (context) => [const SizedBox()],
// //   items: widget.menus.map((SubMenu value) {
// //     return DropdownMenuItem<SubMenu>(
// //       value: value,
// //       child: Padding(
// //         padding: const EdgeInsets.all(8.0),
// //         child: Text(value.text.tr()),
// //       ),
// //     );
// //   }).toList(),
// //
// //   onChanged: (subMenu) {
// //     if (subMenu != null) {
// //       setState(() => page = subMenu);
// //     }
// //   },
// // )
// ],
// ),
}

//
//
//
// class DesktopLayout extends StatefulWidget {
//   final  List<SubMenu> menus;  final DashboardController controller;
//
//   const DesktopLayout({Key? key, required this.menus, required this.controller,}) : super(key: key);
//
//   @override
//   State<DesktopLayout> createState() => _DesktopLayoutState();
// }
//
// class _DesktopLayoutState extends State<DesktopLayout> {
//
//   //
//   // [
//   //
//   // CollapsibleItem(
//   // text: "orders".tr(),
//   // icon: Icons.add_shopping_cart_outlined,
//   // onPressed: () {
//   // setState(() {
//   // context.read<MenuCubit>().setMenu(1);
//   // Navigator.pushNamed(context, RouteList.orders);
//   // });
//   // },
//   // ),
//   // CollapsibleItem(
//   // text: 'config'.tr(),
//   // icon: EvaIcons.settingsOutline,
//   // onPressed: () {
//   // setState(() {
//   // context.read<MenuCubit>().setMenu(2);
//   // Navigator.pushNamed(context, RouteList.configs);
//   // });
//   // },
//   // ),
//   // CollapsibleItem(
//   // text: 'crm'.tr(),
//   // icon: Icons.accessibility_outlined,
//   // onPressed: () {
//   // setState(() {
//   // context.read<MenuCubit>().setMenu(3);
//   // Navigator.pushNamed(context, RouteList.crm);
//   // });
//   // },
//   // ),
//   // CollapsibleItem(
//   // text: 'management'.tr(),
//   // icon: Icons.manage_accounts,
//   // onPressed: () {
//   // setState(() {
//   // context.read<MenuCubit>().setMenu(4);
//   // Navigator.pushNamed(context, RouteList.management);
//   // });
//   // },
//   // ),
//   // CollapsibleItem(
//   // text: 'product'.tr(),
//   // icon: Icons.assessment_outlined,
//   // onPressed: () {
//   // setState(() {
//   // context.read<MenuCubit>().setMenu(5);
//   // Navigator.pushNamed(context, RouteList.product);
//   // });
//   // },
//   // ),
//   // CollapsibleItem(
//   // text: 'signOut'.tr(),
//   // icon: EvaIcons.logOutOutline,
//   // onPressed: () {
//   // setState(() {
//   // context.read<LoginCubit>().logout();
//   //
//   // });
//   // },
//   // ),
//   //
//   // ];
//
//
//   late List<CollapsibleItem> _items;
//
//   late String _headline;
//
//   @override
//   void initState() {
//     super.initState();
//     _items = _generateItems;
//     _headline = _items.firstWhere((item) => item.isSelected).text;
//
//   }
//
//
//   List<CollapsibleItem> get _generateItems {
//     return [
//       CollapsibleItem(
//         text: "orders".tr(),
//         icon: Icons.add_shopping_cart_outlined,
//         onPressed: () {
//           setState(() {
//             _headline = 'DashBoard';
//             BlocProvider.of <MenuCubit>(context).setMenu(1);
//             Navigator.pushNamed(context, RouteList.orders);
//           });
//         },
//         isSelected: true,
//       ),
//       CollapsibleItem(
//         text: 'config'.tr(),
//         icon: EvaIcons.settingsOutline,
//         onPressed: () {
//           setState(() {
//             _headline = 'Errors';
//             BlocProvider.of <MenuCubit>(context).setMenu(2);
//             Navigator.pushNamed(context, RouteList.configs);
//           });
//         },
//       ),
//       CollapsibleItem(
//         text: 'crm'.tr(),
//         icon: Icons.search,
//         onPressed: () {
//           setState(() {
//             _headline = 'Search';
//             BlocProvider.of <MenuCubit>(context).setMenu(3);
//             Navigator.pushNamed(context, RouteList.crm);
//           });
//         },
//       ),
//       CollapsibleItem(
//         text: 'Notifications',
//         icon: Icons.notifications,
//         onPressed: () => setState(() => _headline = 'Notifications'),
//       ),
//       CollapsibleItem(
//         text: 'Settings',
//         icon: Icons.settings,
//         onPressed: () => setState(() => _headline = 'Settings'),
//       ),
//
//     ];
//   }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: CollapsibleSidebar(
//         isCollapsed: MediaQuery.of(context).size.width <= 800,
//         items: _items,
//         // avatarImg: NetworkImage( "https://c4.wallpaperflare.com/wallpaper/764/505/66/baby-groot-4k-hd-superheroes-wallpaper-thumb.jpg"),
//         title: 'John Smith',
//
//         backgroundColor: AppColor.menuBgColor,
//         selectedTextColor: Colors.white,
//         selectedIconColor: Colors.white,
//
//         selectedIconBox: Colors.white12,
//         textStyle: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
//         sidebarBoxShadow: [],
//         titleStyle: const TextStyle(
//           fontSize: 20,
//           fontStyle: FontStyle.italic,
//           color: Colors.white,
//           fontWeight: FontWeight.bold,),
//         toggleTitleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, ),
//
//         onTitleTap: () {
//         },
//         body:  ContentWidget(
//           menus: widget.menus,
//           openDrawer: widget.controller.openDrawer,
//         ),
//
//
//       ),
//     );
//   }
//
//
// }

class IconButtonBar extends StatefulWidget with PreferredSizeWidget {
  const IconButtonBar({
    Key? key,
    required this.childSize,
    required this.children,
  }) : super(key: key);

  final Size childSize;

  final List<Widget> children;

  @override
  Size get preferredSize =>
      Size(childSize.width * children.length, childSize.height);

  @override
  State<IconButtonBar> createState() => _IconButtonBarState();
}

class _IconButtonBarState extends State<IconButtonBar> {
  final GlobalKey buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        int visibleChildren =
            constraints.constrain(widget.preferredSize).width ~/
                widget.childSize.width;
        visibleChildren = (visibleChildren < widget.children.length)
            ? visibleChildren - 1
            : widget.children.length;
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ...widget.children.sublist(0, visibleChildren),
            if (visibleChildren < widget.children.length)
              OverflowMenu(
                  key: buttonKey,
                  children: widget.children
                      .sublist(visibleChildren, widget.children.length)),
          ]
              .map<Widget>((Widget child) =>
                  SizedBox.fromSize(size: widget.childSize, child: child))
              .toList(),
        );
      },
    );
  }
}

class OverflowMenu extends StatefulWidget {
  const OverflowMenu({
    Key? key,
    required this.children,
    this.icon,
  }) : super(key: key);

  final List<Widget> children;
  final Widget? icon;

  @override
  State<OverflowMenu> createState() => _OverflowMenuState();
}

class _OverflowMenuState extends State<OverflowMenu> {
  final GlobalKey buttonKey = GlobalKey();

  final MenuController controller = MenuController();

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: controller,
      style: const MenuStyle(alignment: AlignmentDirectional.bottomStart),
      builder: (context, _, child) {
        return IconButton(
          key: buttonKey,
          icon: widget.icon ??
              const Icon(
                Icons.more_vert,
                color: AppColors.mainTextColor,
              ),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
      menuChildren: widget.children,
    );
  }
}
