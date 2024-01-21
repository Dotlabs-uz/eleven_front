import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/utils/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/components/button_widget.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/route_constants.dart';

class PageNotFound extends StatefulWidget {
final BuildContext context;
  const PageNotFound({Key? key, required this.context}) : super(key: key);

  @override
  State<PageNotFound> createState() => _PageNotFoundState();
}

class _PageNotFoundState extends State<PageNotFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.tLockerLock,
                  height: 300,
                  width: 300,
                ),
                Text(
                  "pageNotFound".tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 150,
                  ),
                  child: ButtonWidget(
                    text: "goToHome",
                    onPressed: ()   {
                      Router.neglect(context, () => context.go(RouteList.home));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
