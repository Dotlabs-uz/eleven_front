import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../entities/field_entity.dart';
import '../utils/app_colors.dart';

class DataTextFieldWidget extends StatefulWidget {
  final FieldEntity? fieldEntity;
  final bool isPasswordField;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final int maxLines;
  final int? maxChar;

  final TextInputFormatter? formatter;

  const DataTextFieldWidget({
    Key? key,
    required this.fieldEntity,
    this.maxChar,
    this.formatter,
    this.controller,
    this.isPasswordField = false,
    this.enabled = true,
    this.maxLines = 1,
    this.validator,
  }) : super(key: key);

  @override
  State<DataTextFieldWidget> createState() => _DataTextFieldWidgetState();
}

class _DataTextFieldWidgetState extends State<DataTextFieldWidget> {
  late TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    textEditingController =
        TextEditingController(text: widget.fieldEntity?.val);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.fieldEntity?.label.tr().toUpperCase() ?? "",
                // style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.start,
                style: GoogleFonts.nunito(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.fieldEntity!.isRequired) const SizedBox(width: 3),
              if (widget.fieldEntity!.isRequired)
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
          TextFormField(
            maxLength: widget.maxChar,
            // initialValue: widget.fieldEntity.val,
            inputFormatters:
                widget.formatter != null ? [widget.formatter!] : [],
            controller: widget.controller ?? textEditingController,
            obscureText: widget.isPasswordField,
            obscuringCharacter: '*',

            validator: widget.validator,
            // controller: controller,

            maxLines: widget.maxLines,
            style: GoogleFonts.nunito(
              color: widget.enabled
                  ? AppColors.enabledTextColor
                  : AppColors.disabledTextColor,
            ),
            // style: Theme.of(context).textTheme.headline6,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              hintText: widget.fieldEntity?.hintText.tr(),
              enabledBorder: widget.fieldEntity!.isRequired
                  ? const OutlineInputBorder(
                      borderSide: BorderSide(
                      color: Colors.grey,
                    ))
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  width: 2,
                  color: widget.fieldEntity!.isRequired
                      ? Colors.blueGrey
                      : const Color(0xFF000000),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  width: 2,
                  color: widget.fieldEntity!.isRequired
                      ? Colors.blueGrey
                      : const Color(0xFF000000),
                ),
              ),
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: AppColors.hintTextColor),
            ),
            enabled: widget.enabled,
            onChanged: (value) => widget.fieldEntity?.val = value,
          ),
        ],
      ),
    );
  }
}
