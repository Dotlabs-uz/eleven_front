import 'package:collection/collection.dart';
import 'package:eleven_crm/features/management/domain/entity/employee_schedule_entity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../../core/utils/color_helper.dart';
import '../../../../core/utils/string_helper.dart';
import '../../domain/entity/employee_entity.dart';
import 'month_selector_with_dates_widget.dart';

class EmployeeScheduleWidget extends StatefulWidget {
  final List<EmployeeEntity> listEmployee;
  final Function(int)? onMonthChanged;
  final Function(EmployeeScheduleFieldEntity)? onFieldSubmit;
  const EmployeeScheduleWidget(
      {Key? key,
        required this.listEmployee,
        this.onMonthChanged,
        this.onFieldSubmit})
      : super(key: key);

  @override
  State<EmployeeScheduleWidget> createState() =>
      _EmployeeScheduleWidgetState();
}

class _EmployeeScheduleWidgetState extends State<EmployeeScheduleWidget> {
  int currentMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
  }

  onMonthChanged(int val) {
    setState(() {
      currentMonth = val;
    });

    widget.onMonthChanged?.call(val);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          // color: Colors.red

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 200,
                ),
                MonthSelectorWithDatesWidget(
                  onMonthChanged: (val) => onMonthChanged(val),
                  currentMonth: currentMonth,
                ),
              ],
            ),
            ...widget.listEmployee.map((e) =>  _EmployeeScheduleFieldWidget(
              employeeEntity: e,
              currentMonth: currentMonth,
              onSelectionTap: (day, month, status) {
                print("Day $day Month $month CurrentStatus $status");
              },
            )),
            // _EmployeeScheduleFieldWidget(
            //   employeeEntity: widget.listEmployee.first,
            //   currentMonth: currentMonth,
            //   onSelectionTap: (day, month, status) {
            //     print("Day $day Month $month CurrentStatus $status");
            //   },
            // )
          ],
        ),
      ),
    );
  }
}

class _EmployeeScheduleFieldWidget extends StatelessWidget {
  final EmployeeEntity employeeEntity;
  final int currentMonth;
  final Function(int, int, int) onSelectionTap;
  const _EmployeeScheduleFieldWidget({
    Key? key,
    required this.employeeEntity,
    required this.currentMonth,
    required this.onSelectionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 35,
          width: 200,
          // color: Colors.red,
          child: _card(),
        ),
        ...List.generate(
          StringHelper.getDaysByMonthIndex(month: currentMonth),
              (index) {
            final day = index + 1;
            final entity = employeeEntity.schedule.firstWhereOrNull((element) {
              final startDateParsing = DateTime.parse(element.startTime);
              final startDate = DateTime(startDateParsing.year,
                  startDateParsing.month, startDateParsing.day);
              final targetDate =
              DateTime(DateTime.now().year, currentMonth, day);

              return startDate.difference(targetDate).inDays == 0;
            });

            return _scheduleItem(
              entity,
                  (status) => onSelectionTap.call(day, currentMonth, status),
            );
          },
        ),
      ],
    );
  }

  _scheduleItem(EmployeeScheduleEntity? entity, Function(int status) onTap) {
    if (entity == null) {
      return GestureDetector(
        onTap: () => onTap.call(EmployeeScheduleStatus.notSelected.index),
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey.shade200),
          ),
          // child: Center(
          //   child: Text("$day"),
          // ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => onTap.call(entity.status),
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: ColorHelper.getColorForScheduleByStatus(entity.status),
          border: Border.all(width: 1, color: Colors.grey.shade200),
        ),
        child: Center(
          child: Text(
            StringHelper.getTitleForScheduleByStatus(entity.status),
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "Nunito",
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  _card() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 10),

        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
          width: 30,
          height: 30,
        ),
        const SizedBox(width: 8),
        // Spacer(),

        Column(
          children: [
            Text(
              employeeEntity.fullName,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              employeeEntity.fullName,
              style: const TextStyle(
                color: Colors.black,
              ),
            )
          ],
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}

class EmployeeScheduleFieldEntity {
  final int month;
  final int date;
  final EmployeeScheduleStatus status;

  EmployeeScheduleFieldEntity({
    required this.month,
    required this.date,
    required this.status,
  });
}
