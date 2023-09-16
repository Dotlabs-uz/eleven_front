// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/assets.dart';

class TextFormFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? title;
  final bool? enabled;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final Color? hintColor;
  final Color? defaultBorderColor;
  final Color? defaultTextColor;
  final String? prefixImageSvg;
  final TextInputType? keyboardType;
  final BoxConstraints? boxConstraints;
  final bool isPassword;
  final bool enableShadow;
  final Function(String)? onChanged;
  final Function(String?)? onSubmit;
  final TextInputFormatter? textInputFormatter;

  const TextFormFieldWidget({
    Key? key,
    required this.controller,
    required this.label,
    this.hintText,
    this.title,
    this.validator,
    this.fillColor,
    this.hintColor,
    this.prefixImageSvg,
    this.keyboardType,
    this.isPassword = false,
    this.enableShadow = true,
    this.defaultBorderColor,
    this.boxConstraints,
    this.defaultTextColor,
    this.onChanged,
    this.onSubmit,
    this.enabled = true,
    this.textInputFormatter,
  }) : super(key: key);

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 54,
      constraints: widget.boxConstraints,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        boxShadow: widget.enableShadow
            ? [
                BoxShadow(
                  color: const Color(0xffC6C6C6).withOpacity(0.25),
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                ),
              ]
            : [],
      ),
      child: TextFormField(
        autofocus: false,
        inputFormatters: widget.textInputFormatter != null
            ? [widget.textInputFormatter!]
            : [],
        enabled: widget.enabled,
        onFieldSubmitted: (value) => widget.onSubmit?.call(value),
        onChanged: (value) => widget.onChanged?.call(value),
        validator: widget.validator,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword && isObscure,
        textAlignVertical: TextAlignVertical.center,
        maxLines: 1,
        style: GoogleFonts.nunito(
          color: Colors.black54,
          // color: const Color(0xff3f3f3f).withOpacity(0.7),
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.nunito(
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          isDense: true,
          fillColor: Colors.white,
          filled: true,
          suffixIcon: _passwordIcon(isDark),
          labelText: widget.label,
          labelStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: widget.defaultTextColor ??
                (isDark ? Colors.black87 : Colors.black54),
          ),
          prefixIcon: widget.prefixImageSvg != null
              ? SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(
                    child: SvgPicture.asset(
                      widget.prefixImageSvg!,
                      color: Colors.black.withOpacity(0.7),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            borderSide: widget.defaultBorderColor != null
                ? BorderSide(
                    color: widget.defaultBorderColor ??
                        (Colors.black.withOpacity(0.7)),
                    width: 2,
                  )
                : BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            borderSide: widget.defaultBorderColor != null
                ? const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  )
                : BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            borderSide: widget.defaultBorderColor != null
                ? const BorderSide(
                    color: Colors.grey,
                    width: 2,
                  )
                : BorderSide.none,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            borderSide: widget.defaultBorderColor != null
                ? const BorderSide(
                    color: Colors.red,
                    width: 2,
                  )
                : BorderSide.none,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.5),
              width: 3,
            ),
          ),
        ),
      ),
    );
  }

  Widget? _passwordIcon(bool isDark) {
    if (widget.isPassword) {
      if (!isObscure) {
        return SizedBox(
          height: 10,
          width: 10,
          child: Center(
            child: GestureDetector(
              onTap: () => setState(() => isObscure = true),
              child: SvgPicture.asset(
                Assets.tClosedEyeIcon,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: () => setState(() => isObscure = false),
          child: Icon(
            Icons.remove_red_eye,
            color: Colors.black.withOpacity(0.7),
            size: 25,
          ),
        );
      }
    }
    return null;
  }
}
