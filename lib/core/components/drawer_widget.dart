import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/main/presensation/cubit/menu/menu_cubit.dart';
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

              _item(
                title: "homeScreen".tr(),
                index: 0,
                icon: Icons.home_filled,
                isActive: state == 0,
                onChanged: (value) => widget.onChanged.call(listEntityPages[0]),
              ),
              _item(
                title: "management".tr(),
                index: 1,
                icon: Icons.manage_accounts_outlined,
                isActive: state == 1,
                onChanged: (value) => widget.onChanged.call(listEntityPages[1]),
              ),
              _item(
                title: "product".tr(),
                index: 2,
                icon: Icons.assessment_outlined,
                isActive: state == 2,
                onChanged: (value) => widget.onChanged.call(listEntityPages[2]),
              ),
              _item(
                title: "config".tr(),
                index: 3,
                icon: EvaIcons.settingsOutline,
                isActive: state == 3,
                onChanged: (value) => widget.onChanged.call(listEntityPages[3]),
              ),
              _item(
                title: "settings".tr(),
                index: 4,
                icon: EvaIcons.settings,
                isActive: state == 4,
                onChanged: (value) => widget.onChanged.call(listEntityPages[4]),
              ),
              _item(
                title: "signOut".tr(),
                index: 5,
                icon: EvaIcons.logOutOutline,
                isActive: state == 5,
                onChanged: (value) => widget.onChanged.call(listEntityPages[5]),
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
