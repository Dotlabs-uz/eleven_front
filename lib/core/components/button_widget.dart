import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final Color? color;
  final Color? titleColor;
  final Color? borderColor;
  final double? fontSize;
  final bool enabled;
  final EdgeInsets? padding;
  final bool isOutlined;
  final bool toUpperCase;
  final Widget? titleWidget;

  const ButtonWidget({
    Key? key,
    this.onTap,
    required this.title,
    this.titleColor,
    this.titleWidget,
    this.padding,
    this.borderColor,
    this.fontSize,
    this.enabled = true,
    this.isOutlined = false,
    this.toUpperCase = true,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
          maxWidth: 335.w,
        ),
      child: InkWell(
        onTap: !enabled
            ? null
            : () async  {
          await HapticFeedback.mediumImpact();

          onTap?.call();
        },
        splashColor: AppColors.darkTextSecond,
        child: Ink(
          height: 44.h,
          padding: padding,

          decoration: BoxDecoration(
            // color: Colors.red,
            color:
            color ?? (AppColors.buttonColor),
            borderRadius: BorderRadius.circular(2.r),
            border: isOutlined
                ? Border.all(
              color:borderColor ?? AppColors.buttonColor,
            )
                : null,
          ),

          child: Center(
            child:titleWidget ??  FittedBox(
              child: Text(
                toUpperCase ?  title.toUpperCase() : title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontFamily: "SFProDisplay",
                  fontSize: fontSize ?? 17.sp,
                  color: titleColor ?? AppColors.background,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
