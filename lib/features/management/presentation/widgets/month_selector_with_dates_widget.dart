import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/utils/color_helper.dart';
import 'package:eleven_crm/core/utils/constants.dart';
import 'package:eleven_crm/core/utils/string_helper.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

class MonthSelectorWithDatesWidget extends StatefulWidget {
  final Function(int) onMonthChanged;
  final int currentMonth;
  const MonthSelectorWithDatesWidget({
    Key? key,
    required this.onMonthChanged,
    required this.currentMonth,
  }) : super(key: key);

  @override
  State<MonthSelectorWithDatesWidget> createState() =>
      _MonthSelectorWithDatesWidgetState();
}

class _MonthSelectorWithDatesWidgetState
    extends State<MonthSelectorWithDatesWidget> {
  late int currentMonth;

  @override
  void initState() {
    currentMonth = widget.currentMonth;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          // color: Colors.amber,
          width: (31 * 35),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (currentMonth != 1) {
                    currentMonth--;
                  }
                  widget.onMonthChanged.call(currentMonth);
                  setState(() {});
                },
                icon: const Icon(
                  Icons.chevron_left_outlined,
                  size: 28,
                  color: Colors.lightBlue,
                ),
                color: Colors.black,
              ),
              Text(
                StringHelper.monthName(month: currentMonth).tr(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () {
                  if (currentMonth != 12) {
                    currentMonth++;
                  }
                  widget.onMonthChanged.call(currentMonth);
                  setState(() {});
                },
                icon: const Icon(
                  Icons.chevron_right_outlined,
                  size: 28,
                  color: Colors.lightBlue,
                ),
                color: Colors.black,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: currentMonth == now.month
              ? _defaultView()
              : _whenMonthChangedView(),
        ),
      ],
    );
  }

  _defaultView() {
    return Row(
      // scrollDirection: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          31 - now.day + 1,
          (index) {
            var fixedIndex = index = now.day + index;

            return _dateItemWidget(
                fixedIndex, currentMonth, DateTime.now().year);
          },
        ),
        SizedBox(
          width: Constants.sizeOfMonthsSpaceInEmployeeSchedule,
        ),
        ...List.generate(
          now.day,
          (index) {
            var fixedIndex = index + 1;

            return _dateItemWidget(
              fixedIndex,
              currentMonth + 1,
              DateTime.now().year,
            );
          },
        )
      ],
    );
  }

  _whenMonthChangedView() {
    return Row(
      // scrollDirection: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        31,
        (index) {
          var fixedIndex = index + 1;
          return _dateItemWidget(fixedIndex, currentMonth, DateTime.now().year);
        },
      ),
    );
  }

  _dateItemWidget(int day, int month, int year) {
    if (StringHelper.getDaysByMonthIndex(month: currentMonth) < day) {
      return const SizedBox(
        width: 35,
        height: 35,
        // color:Colors.red,
        // child: Text(""),
      );
    }

    final conditionNowDay =
        now.day == day && now.month == month && now.year == year;

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 35,
        minWidth: 35,
      ),
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: conditionNowDay ? Colors.blue : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            day.toString(),
            style: TextStyle(
              color: conditionNowDay
                  ? Colors.white
                  : ColorHelper.getColorForCalendar(day, month, year),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            StringHelper.getDayOfWeekType(
              DateTime(year, month, day),
            ).toString().tr().substring(0, 2),
            style: TextStyle(
              color: conditionNowDay
                  ? Colors.white
                  : ColorHelper.getColorForCalendar(day, month, year),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
