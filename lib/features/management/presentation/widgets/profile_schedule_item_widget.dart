import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/date_time_helper.dart';
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
  State<ProfileScheduleItemWidget> createState() => _ProfileScheduleItemWidgetState();
}

class _ProfileScheduleItemWidgetState extends State<ProfileScheduleItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value:
              widget.weeklyScheduleItemEntity.status.index == 1 ? true : false,
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
          child: Text(StringHelper.getDayOfWeekTypeForBarberProfile(
                  widget.day)
              .tr()),
        ),
        const SizedBox(width: 70),
        _SchedulePicker(
          onSelect: (dt) {
            widget.weeklyScheduleItemEntity.workingHours[widget.day].dateFrom =
                dt;
          },
          title: 'fromText',
          hour: Constants.startWork.toInt(),
        ),
        const SizedBox(width: 20),
        _SchedulePicker(
          onSelect: (dt) {
            widget.weeklyScheduleItemEntity.workingHours[widget.day].dateTo =
                dt;
          },
          title: 'toText',
          hour: Constants.endWork.toInt(),
        ),
        const SizedBox(width: 20),
        const Spacer(),
      ],
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
