import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/color_helper.dart';
import '../../../../core/utils/string_helper.dart';
import '../../../management/domain/entity/employee_schedule_entity.dart';
import '../../../management/presentation/widgets/employee_schedule_widget.dart';
import 'package:collection/collection.dart';

class CalendarEmployeeWidget extends StatefulWidget {
  final Function() onRefreshTap;
  final Function(DateTime dateTime) onDateTap;
  final List<EmployeeScheduleEntity> listSchedule;
  const CalendarEmployeeWidget({
    Key? key,
    required this.onRefreshTap,
    required this.onDateTap,
    required this.listSchedule,
  }) : super(key: key);

  @override
  State<CalendarEmployeeWidget> createState() => _CalendarEmployeeWidgetState();
}

class _CalendarEmployeeWidgetState extends State<CalendarEmployeeWidget> {
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
  static int selectedMonth = DateTime.now().month;
  static DateTime selectedDate = DateTime.now();

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
    final firstDayOfWeek = firstDayOfMonth.weekday;

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
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            selectedDate = DateTime.now();
            setState(() {});
            widget.onRefreshTap.call();
          },
          icon: const Icon(
            Icons.refresh,
            size: 24,
            color: Colors.black,
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
            color: Colors.black,
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
            color: Colors.black,
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
                    color: Colors.black,
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
            final currentYear = now.year;
            final isCurrentMonth = selectedMonth == now.month;
            final isCurrentDate = isCurrentMonth && day == now.day;
            final isSelectedDate =
                selectedDate.day == day && selectedDate.month == selectedMonth;

            return _DayItem(
              day: day,
              isWeekend: isWeekend,
              month: selectedMonth,
              selectedDate: selectedDate,
              isCurrentDate: isCurrentDate,
              isSelectedDate: isSelectedDate,
              listEmployeeScheduleField: widget.listSchedule,
              year: currentYear,
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
  final List<EmployeeScheduleEntity> listEmployeeScheduleField;

  const _DayItem({
    required this.day,
    required this.year,
    required this.month,
    required this.isWeekend,
    required this.selectedDate,
    required this.isCurrentDate,
    required this.isSelectedDate,
    required this.listEmployeeScheduleField,
  });

  @override
  State<_DayItem> createState() => _DayItemState();
}

class _DayItemState extends State<_DayItem> {
  static EmployeeScheduleEntity? fieldEntity;

  @override
  void didUpdateWidget(covariant _DayItem oldWidget) {
    initialize();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() {
    initField();
    // if(month != DateTime.now().month) {
    //   print(" month != DateTime.now().month  ${month != DateTime.now().month}");
    //   print("Filed entity ${fieldEntity != null}");
    //   fieldEntity = null;
    //   setState(() {
    //
    //   });
    // }
  }

  initField() {
    if (widget.day != null) {
      final dt = DateTime(widget.year, widget.month, widget.day!);
      // print("Date time ${dt}");

      fieldEntity =
          widget.listEmployeeScheduleField.firstWhereOrNull((element) {

        return DateFormat("yyyy-MM-dd").parse(element.date) == dt;
      });
      setState(() {

      });

      // print(fieldEntity);
    } else {
      fieldEntity = null;
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: fieldEntity != null
            ? ColorHelper.getColorForScheduleByStatus(fieldEntity!.status)
            : null,
        borderRadius: BorderRadius.circular(6),
      ),
      child: widget.day != null
          ? Center(
              child: Text(
                widget.day.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: fieldEntity != null
                      ? Colors.black
                      : widget.isCurrentDate
                          ? Colors.white
                          : widget.isSelectedDate
                              ? Colors.white
                              : widget.isWeekend
                                  ? Colors.red
                                  : Colors.black,
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
//
// class _DayItem extends StatefulWidget {
//   final int? day;
//   final int year;
//   final int month;
//   final bool isWeekend;
//   final DateTime selectedDate;
//   final List<EmployeeScheduleEntity> listEmployeeScheduleField;
//   final Function(DateTime dateTime) onDateTap;
//
//   const _DayItem({
//     required this.day,
//     required this.year,
//     required this.month,
//     required this.isWeekend,
//     required this.selectedDate,
//     required this.onDateTap,
//     required this.listEmployeeScheduleField,
//   });
//
//   @override
//   State<_DayItem> createState() => _DayItemState();
// }
//
// class _DayItemState extends State<_DayItem> {
//   Color? backgroundColor;
//   static int month = -1;
//
//   EmployeeScheduleEntity? scheduleEntity;
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   void didUpdateWidget(covariant _DayItem oldWidget) {
//     if (month != widget.month) {
//       month = widget.month;
//     }
//     super.didUpdateWidget(oldWidget);
//   }
//
//   @override
//   void initState() {
//     initialize();
//     super.initState();
//   }
//
//   initialize() {
//     month = widget.month;
//
//     if (widget.day != null) {
//       final dt = DateTime(widget.year, widget.month, widget.day!);
//       scheduleEntity = widget.listEmployeeScheduleField.firstWhere((element) {
//         final elementDt = DateTime.parse(
//             DateFormat("yyyy-MM-dd").format(DateTime.parse(element.date)));
//
//         return elementDt.isAtSameMomentAs(dt);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: scheduleEntity != null
//             ? ColorHelper.getColorForScheduleByStatus(
//                 scheduleEntity!.status)
//             : Colors.transparent,
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: widget.day != null
//           ? Center(
//               child: Text(
//                 widget.day.toString(),
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: widget.isWeekend ? Colors.red : Colors.black,
//                 ),
//               ),
//             )
//           : const SizedBox(),
//     );
//   }
// }
