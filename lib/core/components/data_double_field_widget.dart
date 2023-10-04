import 'dart:developer';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../entities/field_entity.dart';
import '../utils/app_colors.dart';

class DataDoubleFieldWidget extends StatefulWidget {
  final FieldEntity? fieldEntity;
  final bool isPasswordField;

  //final TextEditingController controller;
  final bool enabled;
  final int maxLines;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(double?)? onChanged;
  final CurrencyTextInputFormatter? currencyTextInputFormatter;
  final List<TextInputFormatter>? inputFormattes;

  const DataDoubleFieldWidget({
    Key? key,
    required this.fieldEntity,
    this.controller,
    this.validator,
    this.inputFormattes,
    this.onChanged,
    //required this.controller,
    this.isPasswordField = false,
    this.enabled = true,
    this.maxLines = 1,
    this.currencyTextInputFormatter,
    // required this.callback,
  }) : super(key: key);

  @override
  State<DataDoubleFieldWidget> createState() => _DataDoubleFieldWidgetState();
}

class _DataDoubleFieldWidgetState extends State<DataDoubleFieldWidget> {
  final TextEditingController controllerField = TextEditingController();

  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
    decimalDigits: 0,
    locale: 'ru',
    symbol: '',
  );

  @override
  void initState() {
    controllerField.text = "";
    initialize();
    super.initState();
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
                validator: (value) => widget.validator?.call(value),
                // initialValue: widget.fieldEntity.val,
                controller: widget.controller ?? controllerField,
                obscureText: widget.isPasswordField,

                obscuringCharacter: '*',
                keyboardType: TextInputType.number,
                inputFormatters: widget.currencyTextInputFormatter != null
                    ? [
                  widget.currencyTextInputFormatter!,
                ]
                    : widget.inputFormattes != null
                    ? widget.inputFormattes!
                    : [],

                // controller: controller,
                maxLines: widget.maxLines,
                style: GoogleFonts.nunito(
                  color: widget.enabled
                      ? AppColors.enabledTextColor
                      : AppColors.disabledTextColor,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hintText: widget.fieldEntity?.hintText.tr(),
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
                  hintStyle: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: AppColors.hintTextColor),
                ),
                enabled: widget.enabled,
                onChanged: (value) {
                  try {
                    if (widget.currencyTextInputFormatter != null) {
                      final unformatted = double.parse(widget
                          .currencyTextInputFormatter!
                          .getUnformattedValue()
                          .toString());
                      widget.fieldEntity?.val = unformatted;

                      widget.onChanged?.call(unformatted);
                    } else {
                      widget.fieldEntity?.val = double.parse(value);
                    }
                    log("Field value  == ${widget.fieldEntity?.val} ${widget
                        .fieldEntity?.hintText ?? ""}");
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
