import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/utils/color_helper.dart';
import 'package:eleven_crm/features/management/domain/entity/employee_schedule_entity.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/string_helper.dart';


class ScheduleCalendarWidget extends StatefulWidget {
  final List<EmployeeScheduleEntity> listSchedule;
  final Function() onRefreshTap;

  const ScheduleCalendarWidget(
      {Key? key, required this.listSchedule, required this.onRefreshTap})
      : super(key: key);

  @override
  State<ScheduleCalendarWidget> createState() => _ScheduleCalendarWidgetState();
}

class _ScheduleCalendarWidgetState extends State<ScheduleCalendarWidget> {
  final List<int?> daysOfMonth = [];
  final List<String> dayNames = [
    "monSmall",
    "tueSmall",
    "wedSmall",
    "thSmall",
    "frSmall",
    "saSmall",
    "suSmall",
  ];
  static int selectedMonth = DateTime.now().month;
  static DateTime selectedDate = DateTime.now();

  List<EmployeeScheduleEntity> listSchedule = [];
  @override
  void initState() {
    _initDaysOfMonth();
    super.initState();
  }

  _initDaysOfMonth() {
    listSchedule = widget.listSchedule;
    daysOfMonth.clear();
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, selectedMonth, 1);
    final lastDayOfMonth = DateTime(now.year, selectedMonth + 1, 0);
    final firstDayOfWeek =
        firstDayOfMonth.weekday; // День недели для первого числа месяца

    // Заполнение пустыми значениями для дней до первого дня месяца
    for (var i = 1; i < firstDayOfWeek; i++) {
      daysOfMonth.add(null);
    }

    // Заполнение датами месяца
    for (var day = 1; day <= lastDayOfMonth.day; day++) {
      daysOfMonth.add(day);
    }
  }

  _monthChange(int selectMonth) {
    if (selectedDate.month != selectMonth) {
      selectedDate = DateTime(selectedDate.year, selectMonth, -1000);
    }
    _initDaysOfMonth();

    listSchedule = widget.listSchedule;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _monthSelector(),
          const SizedBox(height: 20),
          _datesSelection(),
        ],
      ),
    );
  }

  _monthSelector() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: selectedMonth != 1
                ? () {
                    selectedMonth--;
                    _monthChange(selectedMonth);
                  }
                : null,
            icon: const Icon(
              Icons.chevron_left_outlined,
              size: 34,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Text(
            StringHelper.monthName(month: selectedMonth).tr(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: selectedMonth != 12
                ? () {
                    selectedMonth++;
                    _monthChange(selectedMonth);
                  }
                : null,
            icon: const Icon(
              Icons.chevron_right_outlined,
              size: 34,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  _datesSelection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var i = 0; i < 7; i++)
              Center(
                child: Text(
                  dayNames[i].tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemCount: daysOfMonth.length,
          itemBuilder: (context, index) {
            final day = daysOfMonth[index];
            final isWeekend = index % 7 == 5 || index % 7 == 6;
            final now = DateTime.now();
            final isCurrentMonth = selectedMonth == now.month;
            final isCurrentDate = isCurrentMonth && day == now.day;

            return _DayItem(
              day: day,
              isWeekend: isWeekend,
              isCurrentDate: isCurrentDate,
              month: selectedMonth,
              listSchedule: listSchedule,
            );
          },
        ),
      ],
    );
  }
}

class _DayItem extends StatefulWidget {
  final int? day;
  final int month;
  final bool isWeekend;
  final bool isCurrentDate;
  final List<EmployeeScheduleEntity> listSchedule;

  const _DayItem({
    required this.day,
    required this.month,
    required this.isWeekend,
    required this.isCurrentDate,
    required this.listSchedule,
  });

  @override
  State<_DayItem> createState() => _DayItemState();
}

class _DayItemState extends State<_DayItem> {
  Color? backgroundColor;
  static int month = -1;

  @override
  void didUpdateWidget(covariant _DayItem oldWidget) {
    if (month != widget.month) {
      initialize();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() {
    backgroundColor = null;

    month = widget.month;

    initColor();

  }

  initColor() {
    backgroundColor = null;

    for (var element in widget.listSchedule) {
      final formatted = DateTime.parse(element.date);
      if (formatted.day == widget.day &&
          formatted.month == month &&
          formatted.year == DateTime.now().year) {
        backgroundColor =
            ColorHelper.getColorForScheduleByStatusForProfile(element.status);
        setState(() {});
      }else {

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initColor();
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: widget.day != null
          ? Center(
              child: Text(
                "${widget.day}",
                style: TextStyle(
                  fontSize: 18,
                  color: backgroundColor != null ? Colors.white : Colors.black,
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
