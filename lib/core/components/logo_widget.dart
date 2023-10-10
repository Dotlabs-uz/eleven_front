import 'package:flutter/material.dart';

import '../utils/assets.dart';

class LogoWidget extends StatelessWidget {
  final double height;
  const LogoWidget({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: Image.asset(Assets.tLogo),height: height,);
  }
}
