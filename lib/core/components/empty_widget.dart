import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/utils/assets.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(Assets.tEmptyLottie, frameRate: FrameRate(120)),
        Text(
          "empty".tr(),
          style: GoogleFonts.nunito(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
