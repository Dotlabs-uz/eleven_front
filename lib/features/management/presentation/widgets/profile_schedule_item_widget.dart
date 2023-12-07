import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/date_time_helper.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../core/utils/string_helper.dart';
import '../../domain/entity/employee_schedule_entity.dart';
import '../../domain/entity/weekly_schedule_item_entity.dart';

class ProfileScheduleItemWidget extends StatefulWidget {
  final WeeklyScheduleItemEntity weeklyScheduleItemEntity;
  final int day;
  const ProfileScheduleItemWidget({
    Key? key,
    required this.weeklyScheduleItemEntity,
    required this.day,
  }) : super(key: key);

  @override
  State<ProfileScheduleItemWidget> createState() =>
      _ProfileScheduleItemWidgetState();
}

class _ProfileScheduleItemWidgetState extends State<ProfileScheduleItemWidget> {
  String selectedHourFrom = "8";
  String selectedMinuteFrom = "00";
  String selectedHourTo = "22";
  String selectedMinuteTo = "00";

  @override
  void initState() {


    initialize() ;
    super.initState();
  }

  initialize() {

    final from = widget.weeklyScheduleItemEntity.workingHours.first.dateFrom;
    final to = widget.weeklyScheduleItemEntity.workingHours.first.dateTo;

    print("Widget ${widget.weeklyScheduleItemEntity.workingHours.length}  ${widget.weeklyScheduleItemEntity.workingHours} ${widget.weeklyScheduleItemEntity.workingHours.first.dateTo.minute}");
    selectedHourFrom = int.parse(from.hour.toString()).toString();
    selectedMinuteFrom = from.minute.toString() == "0" ? "00":  from.minute.toString();
    selectedHourTo =int.parse(  to.hour.toString()).toString();
    selectedMinuteTo =to.minute.toString() == "0" ? "00":  from.minute.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: "Nunito",
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: widget.weeklyScheduleItemEntity.status.index == 1
                ? true
                : false,
            activeColor: AppColors.accent,
            onChanged: (value) {
              if (value == null) return;

              if (value) {
                widget.weeklyScheduleItemEntity.status =
                    EmployeeScheduleStatus.work;
              } else {
                widget.weeklyScheduleItemEntity.status =
                    EmployeeScheduleStatus.notWork;
              }
              setState(() {});
            },
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 30,
            child: Text(
                StringHelper.getDayOfWeekTypeForBarberProfile(widget.day).tr()),
          ),
          const SizedBox(width: 70),
          Text("fromText".tr()),
          const SizedBox(width: 10),
          Row(
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
                    setState(() {
                      selectedHourFrom = newValue!;
                      widget.weeklyScheduleItemEntity.workingHours[widget.day]
                          .dateFrom = DateTime.now().copyWith(
                        hour: int.parse(selectedHourFrom ), minute: 0 ,
                      );
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
                    setState(() {
                      selectedMinuteFrom = newValue!;
                      widget.weeklyScheduleItemEntity.workingHours[widget.day]
                          .dateFrom = DateTime.now().copyWith(
                        minute: int.parse(selectedMinuteFrom),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(width: 30),
          Text("toText".tr()),
          const SizedBox(width: 10),
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black38, width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<String>(
                  value: selectedHourTo,
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
                    setState(() {
                      selectedHourTo = newValue!;
                      widget.weeklyScheduleItemEntity.workingHours[widget.day]
                          .dateTo = DateTime.now().copyWith(
                        hour: int.parse(selectedHourTo ), minute: 0 ,
                      );
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
                  value: selectedMinuteTo,
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
                    setState(() {
                      selectedMinuteTo = newValue!;
                      widget.weeklyScheduleItemEntity.workingHours[widget.day]
                          .dateTo = DateTime.now().copyWith(
                        minute: int.parse(selectedMinuteTo),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _SchedulePicker extends StatefulWidget {
  final Function(DateTime) onSelect;
  final String title;
  final int hour;
  const _SchedulePicker(
      {Key? key,
      required this.onSelect,
      required this.title,
      required this.hour})
      : super(key: key);

  @override
  State<_SchedulePicker> createState() => _SchedulePickerState();
}

class _SchedulePickerState extends State<_SchedulePicker> {
  late DateTime picked;

  @override
  void initState() {
    picked = DateTime.now().copyWith(hour: widget.hour, minute: 0);
    super.initState();
  }

  _pickTime() async {
    final time = await DateTimeHelper.pickTime(
      context,
      initialDate: picked,
    );

    if (time == null) return;
    picked = DateTime.now().copyWith(hour: time.hour, minute: time.minute);
    widget.onSelect.call(picked);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.title.tr(),
          style: const TextStyle(
            fontSize: 14,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        MouseRegion(
          cursor: MaterialStateMouseCursor.clickable,
          child: GestureDetector(
            onTap: () => _pickTime(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(DateFormat("HH:mm").format(picked)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
