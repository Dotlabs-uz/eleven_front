import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    this.onSearch,
    this.hintText,
    this.controller,
    Key? key,
  }) : super(key: key);

  final Function(String value)? onSearch;
  final String? hintText;
  final TextEditingController? controller;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
   TextEditingController controller = TextEditingController();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() {

    if(widget.controller != null) {
      controller= widget.controller!;

    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(EvaIcons.search),
        border:  InputBorder.none,
        enabledBorder:  InputBorder.none,
        focusedBorder:  InputBorder.none,
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
