import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/responsive.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool isEnabled;
  final Color? color;
  final BorderRadius? borderRadius;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.isEnabled = true,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled ? () => onPressed.call() : null,
      child: Ink(
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 10,
          ),
          constraints: BoxConstraints(
            maxHeight: Responsive.isDesktop(context)
                ? 150
                : MediaQuery.of(context).size.width,
          ),
          width: MediaQuery.of(context).size.width,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
          decoration: BoxDecoration(
            color: color,
            gradient: color != null
                ? null
                : LinearGradient(
                    colors: isEnabled
                        ? [const Color(0xff071E32), const Color(0xff0f2a44)]
                        : [Colors.grey, Colors.grey],
                  ),
            borderRadius: borderRadius ??
                const BorderRadius.all(
                  Radius.circular(6),
                ),
          ),
          child: Text(
            text.tr(),
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: isEnabled ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
