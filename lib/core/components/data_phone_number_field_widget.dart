import 'dart:developer';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../entities/field_entity.dart';
import '../utils/app_colors.dart';

class DataPhoneNumberFieldWidget extends StatefulWidget {
  final FieldEntity? fieldEntity;

  //final TextEditingController controller;
  final bool enabled;
  final TextEditingController? controller;
  final Function(int?)? onChanged;

  const DataPhoneNumberFieldWidget({
    Key? key,
    required this.fieldEntity,
    this.controller,
    this.onChanged,
    //required this.controller,
    this.enabled = true,
    // required this.callback,
  }) : super(key: key);

  @override
  State<DataPhoneNumberFieldWidget> createState() =>
      _DataPhoneNumberFieldWidgetState();
}

class _DataPhoneNumberFieldWidgetState
    extends State<DataPhoneNumberFieldWidget> {
  final TextEditingController controllerField = TextEditingController();

  static MaskTextInputFormatter phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+998#########',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  @override
  void initState() {
    controllerField.text = "";
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    controllerField.dispose()
;    super.dispose();
  }

  initialize() {
    setState(() {
      controllerField.text = widget.fieldEntity?.val.toString() ?? "0";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FittedBox(
                child: Text(
                  widget.fieldEntity?.label.tr().toUpperCase() ?? "",
                  // style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
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
          SizedBox(
            height: 40,
            child: TextFormField(
                controller: widget.controller ?? controllerField,
                obscuringCharacter: '*',
                keyboardType: TextInputType.number,
                inputFormatters: [phoneMaskFormatter],
                style: GoogleFonts.nunito(
                  color: widget.enabled
                      ? AppColors.enabledTextColor
                      : AppColors.disabledTextColor,
                ),
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
                    borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xff071E32),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Color(0xff071E32),
                    ),
                  ),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: AppColors.hintTextColor),
                ),
                enabled: widget.enabled,
                onChanged: (value) {
                  try {
                    final formatted = int.parse(value.replaceAll("+", ""));
                    log("Field value  == $formatted");
                    widget.fieldEntity?.val = formatted;
                    widget.onChanged?.call(formatted);
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
