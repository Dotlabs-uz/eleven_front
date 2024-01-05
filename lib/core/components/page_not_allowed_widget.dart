import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/assets.dart';
import '../../features/main/presensation/cubit/top_menu_cubit/top_menu_cubit.dart';

class PageNotAllowedWidget extends StatefulWidget {
  const PageNotAllowedWidget({Key? key}) : super(key: key);

  @override
  State<PageNotAllowedWidget> createState() => _PageNotAllowedWidgetState();
}

class _PageNotAllowedWidgetState extends State<PageNotAllowedWidget> {
  @override
  void initState() {
    BlocProvider.of<TopMenuCubit>(context).clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(Assets.tLockerLock,height: 300, width: 300,),
          Text(
            "pageNotAllowed".tr(),
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
