// import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../core/utils/assets.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Lottie.asset(
        Assets.tLoadingIndicatorLottie,
      ),
      // const FlareActor(
      //   'assets/animations/loading_circle.flr',
      //   animation: 'load',
      //   snapToEnd: true,
      // ),
    );
  }
}
