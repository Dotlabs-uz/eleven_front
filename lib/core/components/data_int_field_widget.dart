import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../entities/field_entity.dart';
import '../utils/app_colors.dart';

class DataIntFieldWidget extends StatefulWidget {
  final FieldEntity fieldEntity;
  final bool isPasswordField;

  //final TextEditingController controller;
  final bool isEnabled;
  final int maxLines;

  final TextInputFormatter? formatter;

  const DataIntFieldWidget({
    Key? key,
    required this.fieldEntity,
    //required this.controller,
    this.formatter,
    this.isPasswordField = false,
    this.isEnabled = true,
    this.maxLines = 1,
    // required this.callback,
  }) : super(key: key);

  @override
  State<DataIntFieldWidget> createState() => _DataIntFieldWidgetState();
}

class _DataIntFieldWidgetState extends State<DataIntFieldWidget> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController =
        TextEditingController(text: widget.fieldEntity.val.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    textEditingController =
        TextEditingController(text: widget.fieldEntity.val.toString());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FittedBox(
                child: Text(
                  widget.fieldEntity.label.tr().toUpperCase(),
                  // style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.nunito(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (widget.fieldEntity.isRequired) const SizedBox(width: 3),
              if (widget.fieldEntity.isRequired)
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),
          SizedBox(
            height: 40,
            child: TextField(
                // initialValue: widget.fieldEntity.val,
                controller: textEditingController,
                obscureText: widget.isPasswordField,
                obscuringCharacter: '*',
                inputFormatters: widget.formatter != null
                    ? [
                        FilteringTextInputFormatter.digitsOnly,
                        widget.formatter!
                      ]
                    : [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                keyboardType: TextInputType.number,
                // controller: controller,
                maxLines: widget.maxLines,
                // style: Theme.of(context).textTheme.headline6,
                style: GoogleFonts.nunito(
                    color: widget.isEnabled
                        ? AppColors.enabledTextColor
                        : AppColors.disabledTextColor),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.blue,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      width: 2,
                    ),
                  ),
                  hintText: widget.fieldEntity.hintText.tr(),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: AppColors.hintTextColor),
                ),
                enabled: widget.isEnabled,
                onChanged: (value) {
                  try {
                    debugPrint("INTEDGE $value");
                    widget.fieldEntity.val = int.parse(value);
                  } catch (e) {
                    debugPrint("Error $e");
                  }
                }),
          ),
        ],
      ),
    );
  }
}
