import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

import '../utils/assets.dart';

class ImageViewWidget extends StatelessWidget {
  final String avatar;
  final double size;
  const ImageViewWidget({Key? key, required this.avatar, this.size = 60})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return avatar.contains("placeholder.png") || avatar.isEmpty
        ? Container(
            height: size,
            width: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(Assets.tAvatarPlaceHolder))
        : ImageNetwork(
            image: avatar,
            height: size,
            width: size,
            duration: 1500,
            curve: Curves.easeIn,
            fitAndroidIos: BoxFit.cover,
            fitWeb: BoxFitWeb.cover,
            borderRadius: BorderRadius.circular(100),
            onLoading: const CircularProgressIndicator(),
            onError: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          );
  }
}
