import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    this.onSearch,
    this.hintText,
    Key? key,
  }) : super(key: key);

  final Function(String value)? onSearch;
  final String? hintText;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(EvaIcons.search),
        // enabledBorder: OutlineInputBorder(
        //   borderSide: const BorderSide(width: .1),
        //   // borderRadius: BorderRadius.zero
        //   borderRadius: BorderRadius.circular(12),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: const BorderSide(width: .1),
        //   // borderRadius: BorderRadius.zero
        //   borderRadius: BorderRadius.circular(12),
        // ),
        // border: OutlineInputBorder(
        //   borderSide: const BorderSide(width: .1),
        //   // borderRadius: BorderRadius.zero
        //   borderRadius: BorderRadius.circular(12),
        // ),
        hintText: widget.hintText ?? "search".tr(),
      ),
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
        if (widget.onSearch != null) widget.onSearch!(controller.text);
      },
      textInputAction: TextInputAction.search,
      style: GoogleFonts.nunito(color: Colors.grey),
    );
  }
}
