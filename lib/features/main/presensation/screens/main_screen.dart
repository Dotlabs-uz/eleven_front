import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

class MainScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key);

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
              return Container(
                color: AppColors.mainTextColor,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SideMenuWidget(
                      navigationShell: widget.navigationShell,
                      onChanged: (value) {
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                    ),
                    // Flexible(
                    //   flex: constraints.maxWidth > 1350 ? 3 : 4,
                    //   child: SingleChildScrollView(
                    //     controller: ScrollController(),
                    //     child: _buildSidebar(context),
                    //   ),
                    // ),
                    Expanded(
                      child: ContentWidget(
                        navigationShell: widget.navigationShell,
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
              // return ContentWidget(
              //   menus: widget.menus,
              //   openDrawer: () {},
              // );
            },
            tabletBuilder: (context, constraints) {
              return Container(
                color: AppColors.mainTextColor,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SideMenuWidget(
                      navigationShell: widget.navigationShell,
                      onChanged: (value) {
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                    ),
                    // Flexible(
                    //   flex: constraints.maxWidth > 1350 ? 3 : 4,
                    //   child: SingleChildScrollView(
                    //     controller: ScrollController(),
                    //     child: _buildSidebar(context),
                    //   ),
                    // ),
                    Expanded(
                      child: ContentWidget(
                        navigationShell: widget.navigationShell,
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
              // return Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Flexible(
              //       flex: constraints.maxWidth > 800 ? 12 : 10,
              //       child: ContentWidget(
              //         menus: widget.menus,
              //         openDrawer: () {},
              //       ),
              //     ),
              //     SizedBox(
              //       height: MediaQuery.of(context).size.height,
              //       child: const VerticalDivider(),
              //     ),
              //   ],
              // );
            },
            desktopBuilder: (context, constraints) {
              return Container(
                color: AppColors.mainTextColor,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SideMenuWidget(
                      navigationShell: widget.navigationShell,
                      onChanged: (value) {
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                    ),
                    // Flexible(
                    //   flex: constraints.maxWidth > 1350 ? 3 : 4,
                    //   child: SingleChildScrollView(
                    //     controller: ScrollController(),
                    //     child: _buildSidebar(context),
                    //   ),
                    // ),
                    Expanded(
                      child: ContentWidget(
                        navigationShell: widget.navigationShell,
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

class SideMenuWidget extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final Function(int) onChanged;
  const SideMenuWidget({
    Key? key,
    required this.navigationShell,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  static int currentIndex = 0;
  @override
  void initState() {
    currentIndex = widget.navigationShell.currentIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SideMenuWidget oldWidget) {
    if (currentIndex != widget.navigationShell.currentIndex) {
      currentIndex = widget.navigationShell.currentIndex;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if(state is LogoutSuccess) {
            context.go(RouteList.logout);

          }
        },
        child: FloatingMenuWidget(
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
            context.go(RouteList.configs);
          },
          onChanged: (value) {
            if (value.key == RouteList.logout) {
            } else {
              widget.navigationShell.goBranch(
                value.index,
                initialLocation: value.index == widget.navigationShell.currentIndex,
              );

              widget.onChanged.call(value.index);
            }
          },
          currentIndex: currentIndex,
        ),
      ),
    );
  }
}

class ContentWidget extends StatefulWidget {
  const ContentWidget({
    Key? key,
    required this.openDrawer,
    required this.navigationShell,
  }) : super(key: key);
  final void Function() openDrawer;
  final StatefulNavigationShell navigationShell;

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  List<SubMenu> menus = [];
  @override
  void initState() {
    initializeMenus();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ContentWidget oldWidget) {
    if (oldWidget.navigationShell.currentIndex !=
        widget.navigationShell.currentIndex) {
      initializeMenus();
    }

    super.didUpdateWidget(oldWidget);
  }

  initializeMenus() {
    switch (widget.navigationShell.currentIndex) {
      case 0:
        menus = Menus.ordersMenu;

        break;
      case 1:
        menus = Menus.managementMenu;

        break;
      case 2:
        menus = Menus.productMenu;

        break;
    }
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
            child: widget.navigationShell,
          ),
        ],
      ),
    );
  }

  _topMenu() {
    final currentUrl =
        GoRouter.of(context).routeInformationProvider.value.uri.toString();
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            menus.length,
            (index) {
              final item = menus[index];
              final itemUrl = "${item.rootRoute}/${item.route}";
              return InkWell(
                onTap: () {
                  context.go(itemUrl);
                },
                child: Ink(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      border: currentUrl == itemUrl
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
                        menus[index].text.tr().toUpperCase(),
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
              );
            },
          )
        ],
      ),
    );
  }

  _searchAndActionsMenu() {
    final TextEditingController textEditingController = TextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
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
                  child: data.enableSearch
                      ? SearchField(
                          onSearch: data.searchCubit == null
                              ? null
                              : (value) {
                                  data.searchCubit.load(value);
                                },
                        )
                      : const SizedBox.shrink(),
                ),
                ...data.iconList,
              ],
            ),
          );
        },
      ),
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
