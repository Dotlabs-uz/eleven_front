import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/utils/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../entities/field_entity.dart';

class TimeFieldWithoutFieldWidget extends StatefulWidget {
  final bool isEnabled;
  final int maxLines;
  final TimeOfDay value;
  final String? label;
  final Function(DateTime?)? onSelected;

  const TimeFieldWithoutFieldWidget({
    Key? key,
    this.isEnabled = true,
    this.maxLines = 1,
    this.onSelected,
    this.label,
    required this.value,
    // required this.callback,
  }) : super(key: key);

  @override
  State<TimeFieldWithoutFieldWidget> createState() =>
      _TimeFieldWithoutFieldWidgetState();
}

class _TimeFieldWithoutFieldWidgetState
    extends State<TimeFieldWithoutFieldWidget> {
  late TextEditingController textEditingController;

  final now = DateTime.now();
  final DateFormat dateFormat = DateFormat("hh:mm a");

  @override
  void initState() {
    textEditingController =
       TextEditingController(text:  dateFormat.format(
         DateTime(
           now.year,
           now.month,
           now.day,
           widget.value.hour,
           widget.value.minute,
         ),
       ),);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
    widget.label?? "selectTime".tr().toUpperCase(),
              // style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.start,
              style: GoogleFonts.nunito(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
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
                      hintText: "selectTime".tr(),
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
                final selectedTime = await DateTimeHelper.pickTime(context);




                  if(selectedTime != null) {
                    final selectedDateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    textEditingController.text = dateFormat.format(
                      selectedDateTime,
                    );
                    widget.onSelected?.call(selectedDateTime);
                  }
              },
            ),
          ],
        ),
      ],
    );
  }
}
