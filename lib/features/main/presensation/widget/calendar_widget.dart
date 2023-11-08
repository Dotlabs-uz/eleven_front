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
  final int realCurrentMonth = DateTime.now().month;
  int selectedMonth = DateTime.now().month;
  DateTime selectedDate = DateTime.now();

  final List<DateTime> listBlinkedDates = [
    DateTime(2023, 11, 15),
    DateTime(2023, 11, 10),
    // DateTime(2023, 11, 3),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
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
            final now = DateTime.now();
            final isCurrentMonth = selectedMonth == now.month;
            final currentYear = now.year;
            final isCurrentDate = isCurrentMonth && day == now.day;
            final isSelectedDate =
                selectedDate.day == day && selectedDate.month == selectedMonth;

            return _DayItem(
              day: day,
              isWeekend: isWeekend,
              selectedDate: selectedDate,
              isCurrentDate: isCurrentDate,
              isSelectedDate: isSelectedDate,
              listBlinkedDates: listBlinkedDates,
              month: selectedMonth,              year: currentYear,


              onDateTap: (dateTime) {
                if (day != null) {
                  selectedDate = DateTime(currentYear, selectedMonth, day);

                  debugPrint("Selected removed $selectedDate");

                  widget.onDateTap.call(selectedDate);
                  listBlinkedDates.remove(dateTime);
                  setState(() {});
                }
              },
            );
          },
        ),
      ],
    );
  }
}

class _DayItem extends StatefulWidget {
  final int? day;
  final int year;
  final int month;
  final bool isWeekend;
  final bool isSelectedDate;
  final bool isCurrentDate;
  final DateTime selectedDate;
  final List<DateTime> listBlinkedDates;
  final Function(DateTime dateTime) onDateTap;

  const _DayItem({
    required this.day,
    required this.year,
    required this.month,
    required this.isWeekend,
    required this.selectedDate,
    required this.isCurrentDate,
    required this.isSelectedDate,
    required this.listBlinkedDates,
    required this.onDateTap,
  });

  @override
  State<_DayItem> createState() => _DayItemState();
}

class _DayItemState extends State<_DayItem> {
  Color? backgroundColor;
  static int month = -1;
  static List<DateTime> listBlinkedDates = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _DayItem oldWidget) {
    if (month != widget.month ||
        (listBlinkedDates.length != widget.listBlinkedDates.length)) {
      print(
          "listBlinkedDates.length != widget.listBlinkedDates.length ${listBlinkedDates.length} ${widget.listBlinkedDates.length}");
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
    listBlinkedDates = widget.listBlinkedDates;

    month = widget.month;
    if (widget.day != null) {
      _startBlinking();
    }
  }

  void _startBlinking() async {
    if (widget.day == null) return;

    final dt = DateTime(widget.year, month, widget.day!);
    final condition = listBlinkedDates.contains(dt);

    if (condition) {
      timer(10000000000).listen((value) {
        final localCondition = listBlinkedDates.contains(dt);

        if (localCondition == false || month != DateTime.now().month) {
          backgroundColor= null;
          setState(() {

          });
          return;
        }

        setState(() {
          backgroundColor = value % 2 == 0 ? Colors.purple : null;
        });
      });
    }
  }

  Stream<int> timer(int duration) async* {
    for (var i = 0; i < duration; i++) {
      await Future.delayed(const Duration(seconds: 1));
      yield i;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (widget.day != null) {
            widget.onDateTap.call(widget.selectedDate);
            backgroundColor = null;
            listBlinkedDates
                .remove(DateTime(widget.year, widget.month, widget.day!));

            _startBlinking();
            print(
                "Remove date time ${DateTime(widget.year, widget.month, widget.day!)}");
            setState(() {});
          }
        },
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: backgroundColor ??
                (widget.day == null
                    ? null
                    : widget.isSelectedDate
                        ? Colors.pink.shade400
                        : widget.isCurrentDate
                            ? Colors.blue.shade200
                            : null),
            borderRadius: BorderRadius.circular(6),
          ),
          child: widget.day != null
              ? Center(
                  child: Text(
                    widget.day.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.isSelectedDate
                          ? Colors.white
                          : backgroundColor == Colors.purple
                              ? Colors.white
                              : widget.isWeekend
                                  ? Colors.red
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
