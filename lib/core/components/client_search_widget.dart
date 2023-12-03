// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

import '../utils/assets.dart';

class ClientSearchWidget extends StatefulWidget {
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

  const ClientSearchWidget({
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
  State<ClientSearchWidget> createState() => _ClientSearchWidgetState();
}

class _ClientSearchWidgetState extends State<ClientSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: false,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black38,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Text(widget.label),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 40,
                child: SearchAnchor(
                  viewShape:    RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  viewConstraints:
                  const BoxConstraints(maxWidth: 100, minWidth: 100),
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      trailing: [],
                      controller: controller,
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStatePropertyAll<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      side: const MaterialStatePropertyAll<BorderSide>(
                        BorderSide.none,
                      ),
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                      ),
                      onTap: () => controller.openView(),
                      onChanged: (_) => controller.openView(),
                      leading: const SizedBox(),
                    );
                  },
                  suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    return List<ListTile>.generate(5, (int index) {
                      final String item = 'item $index';
                      return ListTile(
                        title: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 4,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            controller.closeView(item);
                          });
                        },
                      );
                    });
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 40,
                child: SearchAnchor(
                  viewShape:    RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  viewConstraints:
                      const BoxConstraints(maxWidth: 100, minWidth: 100),
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      trailing: [],
                      controller: controller,
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStatePropertyAll<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      side: const MaterialStatePropertyAll<BorderSide>(
                        BorderSide.none,
                      ),
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                      ),
                      onTap: () => controller.openView(),
                      onChanged: (_) => controller.openView(),
                      leading: const SizedBox(),
                    );
                  },
                  suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    return List<ListTile>.generate(5, (int index) {
                      final String item = 'item $index';
                      return ListTile(
                        title: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 4,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            controller.closeView(item);
                          });
                        },
                      );
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
