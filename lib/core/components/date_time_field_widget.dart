import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/utils/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../entities/field_entity.dart';

final List<String> listTimes = [
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "10",
  "11",
  "12",
  "13",
  "14",
  "15",
  "16",
  "17",
  "18",
  "19",
  "20",
  "21",
  "22",
  "23",
  "24",
];
final List<String> listMinutes = [

  ...List.generate(61, (index) {
    return index.toString() =="0"  ? "00":index.toString();
  }),
];

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
  String selectedHourFrom = "8";
  String selectedMinuteFrom = "00";

  @override
  void initState() {
    textEditingController =
        TextEditingController(text: widget.fieldEntity.val.toString());
    isFirstInit = true;
    selectedHourFrom = extractHours(widget.fieldEntity.val);
    selectedMinuteFrom = extractMinutes(widget.fieldEntity.val);
    super.initState();
  }

  String extractHours(DateTime time) {
    return time.hour.toString();
  }

  String extractMinutes(DateTime time) {

    return time.minute.toString() == "0" ? "00" : time.minute.toString();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat f = widget.withTime
        ? DateFormat('yyyy-MM-dd HH:mm')
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
        Text(
          widget.fieldEntity.label.tr().toUpperCase(),
          // style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.start,
          style: GoogleFonts.nunito(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.calendar_today),
              tooltip: 'Tap to open date picker',
              onPressed: () async {
                DateTime? beginDate = await DateTimeHelper.pickDate(context,
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
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                    // initialValue: widget.fieldEntity.val,
                    controller: textEditingController,
                    obscuringCharacter: '*',

                    // controller: controller,
                    maxLines: widget.maxLines,
                    style: GoogleFonts.nunito(color: Colors.black54),
                    // style: Theme.of(context).textTheme.headline6,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          color: Color(0xff071E32),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 2,
                          color: Color(0xff071E32),
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
            if (widget.withTime)
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black38, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButton<String>(
                        value: selectedHourFrom,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: listTimes.map((String items) {
                          return DropdownMenuItem(
                            value: items.toString(),
                            child: Text(items.toString()),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          final DateTime dt = widget.fieldEntity.val;
                          setState(() {
                            selectedHourFrom = newValue!;
                            widget.fieldEntity.val = dt.copyWith(hour: int.parse(selectedHourFrom));
                          });
                        },
                      ),
                    ),
                    const Text(
                      "-",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black38, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButton<String>(
                        value: selectedMinuteFrom,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: listMinutes.map((String items) {
                          return DropdownMenuItem(
                            value: items.toString(),
                            child: Text(items.toString()),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          final DateTime dt = widget.fieldEntity.val;
                          setState(() {
                            selectedMinuteFrom = newValue!;
                              widget.fieldEntity.val = dt.copyWith(minute: int.parse(selectedMinuteFrom));

                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
