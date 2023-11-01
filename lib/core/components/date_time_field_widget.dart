import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/utils/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../entities/field_entity.dart';

class DateTimeFieldWidget extends StatefulWidget {
  final FieldEntity fieldEntity;
  final bool isEnabled;
  final bool withTime;
  final int maxLines;
  final Function(DateTime)? onChanged;
  const DateTimeFieldWidget({
    Key? key,
    required this.fieldEntity,
    this.isEnabled = true,
    this.withTime = false,
    this.maxLines = 1,
    this.onChanged,
    // required this.callback,
  }) : super(key: key);

  @override
  State<DateTimeFieldWidget> createState() => _DateTimeFieldWidgetState();
}

class _DateTimeFieldWidgetState extends State<DateTimeFieldWidget> {
  late TextEditingController textEditingController;
  bool isFirstInit = true;

  @override
  void initState() {
    textEditingController =
        TextEditingController(text: widget.fieldEntity.val.toString());
    isFirstInit = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat f = widget.withTime
        ? DateFormat('yyyy-MM-dd hh:mm')
        : DateFormat('yyyy-MM-dd');
    textEditingController =
        TextEditingController(text: f.format(widget.fieldEntity.val));

    if (isFirstInit) {
      widget.onChanged?.call(widget.fieldEntity.val);
      isFirstInit = false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.fieldEntity.label.tr().toUpperCase(),
              // style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.start,
              style: GoogleFonts.nunito(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.fieldEntity.isRequired) const SizedBox(width: 5),
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
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                    // initialValue: widget.fieldEntity.val,
                    controller: textEditingController,
                    obscuringCharacter: '*',

                    // controller: controller,
                    maxLines: widget.maxLines,
                    style: GoogleFonts.nunito(color: Colors.green),
                    // style: Theme.of(context).textTheme.headline6,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 2,
                        ),
                      ),
                      hintText: widget.fieldEntity.hintText.tr(),
                      hintStyle:
                          Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: Colors.red,
                              ),
                    ),
                    enabled: false,
                    onChanged: (value) {}),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              tooltip: 'Tap to open date picker',
              onPressed: () async {
                DateTime? beginDate = widget.withTime
                    ? await DateTimeHelper.pickDateWithTime(context)
                    : await DateTimeHelper.pickDate(context,
                        initialDate: widget.fieldEntity.val);

                setState(() {
                  if (beginDate != null) {
                    try {
                      widget.fieldEntity.val = beginDate;
                      widget.onChanged?.call(widget.fieldEntity.val);

                    } catch (e) {
                      log("Error $e");
                    }
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
