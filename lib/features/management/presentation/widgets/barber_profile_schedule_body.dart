import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/utils/string_helper.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_entity.dart';
import 'package:eleven_crm/features/management/domain/entity/weekly_schedule_item_entity.dart';
import 'package:eleven_crm/features/management/presentation/cubit/employee/employee_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/error_flash_bar.dart';
import '../../../../core/components/success_flash_bar.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/date_time_helper.dart';
import '../../domain/entity/employee_schedule_entity.dart';

class BarberProfileScheduleBody extends StatelessWidget {
  final BarberEntity barberEntity;
  const BarberProfileScheduleBody({Key? key, required this.barberEntity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCubit, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeWeeklyScheduleSaved) {
          SuccessFlushBar("change_success".tr()).show(context);
        } else if (state is EmployeeError) {
          ErrorFlushBar("change_error".tr(args: [state.message])).show(context);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(barberEntity.weeklySchedule.schedule.length,
                (index) {
              final WeeklyScheduleItemEntity element =
                  barberEntity.weeklySchedule.schedule[index];

              return Column(
                children: [
                  const SizedBox(height: 10),
                  _ScheduleItem(barberScheduleEntity: element, day: index),
                  const SizedBox(height: 10),
                  const Divider(),
                ],
              );
            }),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<EmployeeCubit>(context)
                          .saveWeeklySchedule(
                              employeeId: barberEntity.id,
                              weeklySchedule: barberEntity.weeklySchedule);
                    },
                    child: Text(
                      "save".tr(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleItem extends StatefulWidget {
  final WeeklyScheduleItemEntity barberScheduleEntity;
  final int day;
  const _ScheduleItem({
    Key? key,
    required this.barberScheduleEntity,
    required this.day,
  }) : super(key: key);

  @override
  State<_ScheduleItem> createState() => _ScheduleItemState();
}

class _ScheduleItemState extends State<_ScheduleItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: widget.barberScheduleEntity.status.index == 1 ? true : false,
          activeColor: AppColors.accent,
          onChanged: (value) {
            if (value == null) return;

            if (value) {
              widget.barberScheduleEntity.status = EmployeeScheduleStatus.work;
            } else {
              widget.barberScheduleEntity.status =
                  EmployeeScheduleStatus.notWork;
            }
            setState(() {});
          },
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 30,
          child: Text(StringHelper.getDayOfWeekType(
                  DateTime.now().copyWith(day: widget.day - 1))
              .tr()),
        ),
        const SizedBox(width: 70),
        _SchedulePicker(
          onSelect: (dt) {
            widget.barberScheduleEntity.workingHours[widget.day].dateFrom = dt;
          },
          title: 'fromText',
          hour: Constants.startWork.toInt(),
        ),
        const SizedBox(width: 20),
        _SchedulePicker(
          onSelect: (dt) {
            widget.barberScheduleEntity.workingHours[widget.day].dateTo = dt;
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

class ValueItem {
  final String title;
  final String value;

  ValueItem({required this.title, required this.value});
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
