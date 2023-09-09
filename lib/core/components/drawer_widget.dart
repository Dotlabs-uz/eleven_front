import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/main/presensation/cubit/menu/menu_cubit.dart';
import '../utils/app_colors.dart';
import '../utils/assets.dart';
import '../utils/route_constants.dart';
import 'floating_menu_widget.dart';

class DrawerWidget extends StatefulWidget {
  final Function(FloatingMenuEntity) onChanged;
  final String version;

  const DrawerWidget({
    Key? key,
    required this.onChanged,
    required this.version,
  }) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final List<FloatingMenuEntity> listEntity = [
    FloatingMenuEntity(
      key: RouteList.orders,
      icon: Icons.add_shopping_cart_outlined,
      title: "orders".tr(),
      index: 0,
    ),
    FloatingMenuEntity(
      key: RouteList.crm,
      icon: Icons.accessibility_outlined,
      title: "crm".tr(),
      index: 2,
    ),
    FloatingMenuEntity(
      key: RouteList.management,
      icon: Icons.manage_accounts_outlined,
      title: "management".tr(),
      index: 3,
    ),
    FloatingMenuEntity(
      key: RouteList.product,
      icon: Icons.assessment_outlined,
      title: "product".tr(),
      index: 4,
    ),
    FloatingMenuEntity(
      key: RouteList.configs,
      icon: EvaIcons.settingsOutline,
      title: "config".tr(),
      index: 1,
    ),
    FloatingMenuEntity(
      key: RouteList.logout,
      icon: EvaIcons.logOutOutline,
      title: "signOut".tr(),
      index: 5,
    ),
    FloatingMenuEntity(
      key: RouteList.statistic,
      icon: EvaIcons.barChart2,
      title: "statistic".tr(),
      index: 6,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCubit, int>(
      builder: (context, state) {
        log(("Index $state"));
        return Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Image.asset(
                  Assets.tLogo,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "${"Balance".tr()}: ",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "${"ShopBalance".tr()}: ",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              _item(
                title: "orders".tr(),
                index: 0,
                icon: Icons.add_shopping_cart_outlined,
                isActive: state == 0,
                onChanged: (value) => widget.onChanged.call(listEntity[0]),
              ),
              _item(
                title: "management".tr(),
                index: 3,
                icon: Icons.manage_accounts_outlined,
                isActive: state == 3,
                onChanged: (value) => widget.onChanged.call(listEntity[2]),
              ),
              _item(
                title: "product".tr(),
                index: 4,
                icon: Icons.assessment_outlined,
                isActive: state == 4,
                onChanged: (value) => widget.onChanged.call(listEntity[3]),
              ),
              _item(
                title: "config".tr(),
                index: 1,
                icon: EvaIcons.settingsOutline,
                isActive: state == 1,
                onChanged: (value) => widget.onChanged.call(listEntity[4]),
              ),
              _item(
                title: "statistic".tr(),
                index: 6,
                icon: EvaIcons.barChart2,
                isActive: state == 6,
                onChanged: (value) => widget.onChanged.call(listEntity[6]),
              ),
              _item(
                title: "signOut".tr(),
                index: 5,
                icon: EvaIcons.logOutOutline,
                isActive: state == 5,
                onChanged: (value) => widget.onChanged.call(listEntity[5]),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Version: ${widget.version}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _item({
    required Function(int) onChanged,
    required String title,
    required int index,
    required IconData icon,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onChanged.call(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isActive ? Colors.orange : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: isActive ? Colors.white : Colors.black,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
