// ignore_for_file: must_be_immutable

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class ErrorFlushBar extends Flushbar {
  final String msg;

  ErrorFlushBar(this.msg, {Key? key}) : super(key: key);

  @override
  String? get message => msg;

  @override
  Duration? get duration => const Duration(seconds: 4);

  @override
  Color? get leftBarIndicatorColor => AppColors.errorColor;

  @override
  Widget? get icon => const Icon(
        Icons.info_outline,
        size: 28.0,
        color: AppColors.errorColor,
      );

  @override
  EdgeInsets get margin => const EdgeInsets.all(8);

// @override
// BorderRadius? get borderRadius => BorderRadius.circular(8);
}
