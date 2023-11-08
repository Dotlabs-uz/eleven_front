import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/string_helper.dart';

class CalendarWidget extends StatefulWidget {
  final Function() onRefreshTap;
  final Function(DateTime dateTime) onDateTap;
  const CalendarWidget(
      {Key? key, required this.onRefreshTap, required this.onDateTap})
      : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
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
  final int realCurrentMoth = DateTime.now().month;
  int selectedMonth = DateTime.now().month;
  DateTime selectedDate = DateTime.now();
  final List<DateTime> listBlinkedDates = [
    DateTime(2023,11,10),
  ];

  // Добавьте таймер для управления миганием дат
  Timer? blinkTimer;

  @override
  void dispose() {
    blinkTimer?.cancel(); // Отменяем таймер при уничтожении виджета
    super.dispose();
  }

  @override
  initState() {
    _initDaysOfMonth();
    super.initState();
  }

  _initDaysOfMonth() {
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

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          // border: Border.all(color: Colors.black),
          // borderRadius: BorderRadius.circular(10),
          ),
      width: 280,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _monthSelector(),
          const SizedBox(height: 10),
          _datesSelection(),
        ],
      ),
    );
  }

  _monthSelector() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 7),
        Text(
          StringHelper.monthName(month: selectedMonth).tr(),
          style: const TextStyle(
            color: AppColors.calendarMonthColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.refresh,
            size: 24,
            color: AppColors.calendarButtonsColor,
          ),
        ),
        const SizedBox(width: 6),
        IconButton(
          onPressed: selectedMonth != 1
              ? () {
                  selectedMonth--;
                  _monthChange(selectedMonth);
                }
              : null,
          icon: const Icon(
            Icons.chevron_left_outlined,
            size: 24,
            color: AppColors.calendarButtonsColor,
          ),
        ),
        const SizedBox(width: 6),
        IconButton(
          onPressed: selectedMonth != 12
              ? () {
                  selectedMonth++;
                  _monthChange(selectedMonth);
                }
              : null,
          icon: const Icon(
            Icons.chevron_right_outlined,
            size: 24,
            color: AppColors.calendarButtonsColor,
          ),
        ),
      ],
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
                    color: AppColors.calendarWeekdayTitleColor,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemCount: daysOfMonth.length,
          itemBuilder: (context, index) {
            final day = daysOfMonth[index];
            final isWeekend =
                index % 7 == 5 || index % 7 == 6; // Суббота и воскресенье

            return _dayItem(day, isWeekend);
          },
        ),
      ],
    );
  }

  _dayItem(int? day, bool isWeekend) {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    final isCurrentMonth = selectedMonth == currentMonth;
    final isCurrentDate = isCurrentMonth && day == now.day;
    final isSelectedDate =
        selectedDate.day == day && selectedDate.month == selectedMonth;


    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (day != null) {
            selectedDate = DateTime(currentYear, selectedMonth, day);

            debugPrint("Selected date $selectedDate");

            widget.onDateTap.call(selectedDate);
            setState(() {});
          }
        },
        borderRadius: BorderRadius.circular(6),
        child: Ink(
          decoration: BoxDecoration(
            color: day == null
                ? null
                : isSelectedDate
                    ? Colors.pink.shade400
                    : isCurrentDate
                        ? Colors.blue.shade200
                        : null,
            borderRadius: BorderRadius.circular(6),
          ),
          child: day != null
              ? Center(
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelectedDate
                          ? Colors.white
                          : isWeekend
                              ? Colors.red
                              : isCurrentDate
                                  ? Colors.white
                                  : Colors.white,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
