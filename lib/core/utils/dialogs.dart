import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/utils/responsive.dart';
import 'package:eleven_crm/features/main/presensation/cubit/order_filter_cubit.dart';
import 'package:eleven_crm/features/management/domain/entity/employee_schedule_entity.dart';
import 'package:eleven_crm/features/management/presentation/cubit/employee_schedule/employee_schedule_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/management/domain/entity/weekly_schedule_item_entity.dart';
import '../../features/management/presentation/widgets/employee_schedule_widget.dart';
import '../components/button_widget.dart';
import '../components/time_field_widget.dart';
import 'assets.dart';
import 'selections.dart';
import 'string_helper.dart';

final List<String> listTimes = [
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
];
final List<String> listMinutes = [
  "00",
  "5",
  "10",
  "15",
  "20",
  "25",
  "30",
  "35",
  "40",
  "45",
  "50",
  "55",
  "60",
];

class Dialogs {
  static exitDialog({
    required BuildContext context,
    required Function() onExit,
  }) {
    return showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Container(
          color: Colors.white,
          constraints: BoxConstraints(
            maxWidth: Responsive.isDesktop(context)
                ? 100
                : MediaQuery.of(context).size.width,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 33),
              Container(
                height: 123,
                width: 123,
                decoration: BoxDecoration(
                  color: const Color(0xffFA3E3E).withOpacity(0.75),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.tWarningIcon,
                    height: 60,
                    width: 60,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'exit'.tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'DoYouReallyWantToExit'.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: const Color(0xff696969),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 66),
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        text: 'back'.tr().toLowerCase(),
                        onPressed: () => Navigator.pop(context),
                        color: const Color(0xffABACAE),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ButtonWidget(
                        text: 'exit'.tr().toLowerCase(),
                        color: const Color(0xffFA3E3E).withOpacity(0.75),
                        onPressed: () {
                          onExit.call();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static timeTableBarberDialog({
    required BuildContext context,
    required Function(DateTime from, DateTime to) onTimeConfirm,
    required Function() onChangeEmployeeSchedule,
    required Function() onDeleteEmployeeFromTable,
    required String employeeId,
  }) {
    return showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: _TimeTableBarberDialogBody(
          onTimeSelected: (timeFrom, timeTo) => onTimeConfirm.call(
            timeFrom,
            timeTo,
          ),
          onDeleteEmployeeFromTable: onDeleteEmployeeFromTable,
          employeeId: employeeId,
          onChangeEmployeeSchedule: onChangeEmployeeSchedule,
        ),
      ),
    );
  }

  static scheduleField({
    required BuildContext context,
    required Function(
      int status,
      String fromHour,
      String fromMinute,
      String toHour,
      String toMinute,
    ) onConfirm,
    int? day,
    int? month,
    int? year,
    Map<String, dynamic>? workingHours,
    List<WeeklyScheduleItemEntity>? schedule,
  }) {
    return showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: _ScheduleFieldContentDialog(
          day: day,
          month: month,
          year: year,
          onConfirm: onConfirm,
          schedule: schedule,
        ),
      ),
    );
  }
}

class _ScheduleFieldContentDialog extends StatefulWidget {
  final int? day;
  final int? month;
  final int? year;
  final List<WeeklyScheduleItemEntity>? schedule;
  final Function(
    int status,
    String fromHour,
    String fromMinute,
    String toHour,
    String toMinute,
  ) onConfirm;
  const _ScheduleFieldContentDialog(
      {Key? key,
      this.day,
      this.month,
      this.year,
      required this.onConfirm,
      required this.schedule})
      : super(key: key);

  @override
  State<_ScheduleFieldContentDialog> createState() =>
      _ScheduleFieldContentDialogState();
}

class _ScheduleFieldContentDialogState
    extends State<_ScheduleFieldContentDialog> {
  int selectedStatus = 1;
  String selectedTimeFromHour = "8";
  String selectedTimeFromMinute = "00";
  String selectedTimeToHour = "22";
  String selectedTimeToMinute = "00";
  String lastFilteredQuery = "";

  @override
  void initState() {
    lastFilteredQuery = BlocProvider.of<OrderFilterCubit>(context).state.query;
    final formattedFilterQuery = DateTime.tryParse(lastFilteredQuery);

    int weekDay = 1;
    if (formattedFilterQuery == null) {
      weekDay = DateTime.now().weekday;
    } else {
      final dt = DateTime(formattedFilterQuery.year, formattedFilterQuery.month,
          formattedFilterQuery.day);
      final now = DateTime.now()
          .copyWith(hour: 0, minute: 0, millisecond: 0, microsecond: 0);

      if (now.difference(dt).inDays == 0) {
        weekDay = DateTime.now().weekday;
      } else {
        weekDay = StringHelper.getWeekDayByDate(formattedFilterQuery.day,
                formattedFilterQuery.month, formattedFilterQuery.year)
            .index;
      }
    }

    if (widget.schedule != null) {
      final schedule = widget.schedule![weekDay + 1];
      selectedTimeToMinute = _getMinutesTo(schedule.workingHours.first.dateTo);
      selectedTimeToHour = _getHoursTo(schedule.workingHours.first.dateTo);
      selectedTimeFromMinute =
          _getMinutesFrom(schedule.workingHours.first.dateFrom);
      selectedTimeFromHour =
          _getHoursFrom(schedule.workingHours.first.dateFrom);
    }

    if (mounted) {
      Future.delayed(
        Duration.zero,
        () {
          setState(() {});
        },
      );
    }

    lastFilteredQuery = BlocProvider.of<OrderFilterCubit>(context).state.query;
    print('From: $selectedTimeFromHour:$selectedTimeFromMinute');
    print('To: $selectedTimeToHour:$selectedTimeToMinute');
    super.initState();
  }

  String _getHoursTo(DateTime dt) {
    return dt.hour.toString();
  }

  String _getMinutesTo(DateTime dt) {
    return dt.minute.toString() == "0" ? "00" : dt.minute.toString();
  }

  String _getHoursFrom(DateTime dt) {
    return dt.hour.toString();
  }

  String _getMinutesFrom(DateTime dt) {
    return dt.minute.toString() == "0" ? "00" : dt.minute.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: Responsive.isDesktop(context)
            ? 300
            : MediaQuery.of(context).size.width,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "pleaseSelectStatus".tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          widget.day != null
              ? Text(
                  DateTime.tryParse(lastFilteredQuery) != null
                      ? "${DateTime.parse(lastFilteredQuery).day} ${StringHelper.monthName(month: DateTime.parse(lastFilteredQuery).month).tr()} ${DateTime.parse(lastFilteredQuery).year}."
                      : "${widget.day} ${widget.month != null ? StringHelper.monthName(month: widget.month!).tr() : ""} ${widget.year}.",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: 15),

          Text("typeDay".tr()),
          const SizedBox(height: 10),

          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Theme(
              data: ThemeData(
                fontFamily: "Nunito",
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black38, width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<int>(
                  value: selectedStatus,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: Selections.listStatusIndex
                      .map((StatusEmployeeScheduleEntity item) {
                    return DropdownMenuItem<int>(
                      value: item.status,
                      child: Text(item.title),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedStatus = newValue!;
                    });
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          Text("workingTime".tr()),
          const SizedBox(height: 10),

          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: Theme(
              data: ThemeData(
                fontFamily: "Nunito",
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black38, width: 1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: DropdownButton<String>(
                            value: selectedTimeFromHour,
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
                                selectedTimeFromHour = newValue!;
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
                            value: selectedTimeFromMinute,
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
                                selectedTimeFromMinute = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Row(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black38, width: 1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: DropdownButton<String>(
                            value: selectedTimeToHour,
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
                                selectedTimeToHour = newValue!;
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
                            value: selectedTimeToMinute,
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
                                selectedTimeToMinute = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),
          SizedBox(
            height: 40,
            child: ButtonWidget(
              text: 'save'.tr(),
              onPressed: () {
                Navigator.pop(context);
                // required int status,
                // required int fromHour,
                // required int fromMinute,
                // required int toHour,
                // required int toMinute,
                widget.onConfirm.call(
                  selectedStatus,
                  selectedTimeFromHour,
                  selectedTimeFromMinute,
                  selectedTimeToHour,
                  selectedTimeToMinute,
                );
              },
            ),
          ),
          // SizedBox(
          //   height: 35,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Expanded(
          //         child: ButtonWidget(
          //           text: 'back'.tr(),
          //           onPressed: () => Navigator.pop(context),
          //           color: const Color(0xffABACAE),
          //         ),
          //       ),
          //       const SizedBox(width: 15),
          //       Expanded(
          //         child: ButtonWidget(
          //           text: 'save'.tr(),
          //           color: const Color(0xff99C499).withOpacity(0.75),
          //           onPressed: () {
          //             onConfirm.call();
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _TimeTableBarberDialogBody extends StatefulWidget {
  final String employeeId;
  final Function(DateTime timeFrom, DateTime timeTo) onTimeSelected;
  final Function() onDeleteEmployeeFromTable;
  final Function() onChangeEmployeeSchedule;
  const _TimeTableBarberDialogBody({
    Key? key,
    required this.employeeId,
    required this.onChangeEmployeeSchedule,
    required this.onTimeSelected,
    required this.onDeleteEmployeeFromTable,
  }) : super(key: key);

  @override
  State<_TimeTableBarberDialogBody> createState() =>
      _TimeTableBarberDialogBodyState();
}

enum _TimeTableEmployeeDialogState {
  initial,
  selectNotWorkingTIme,
  another,
}

class _TimeTableBarberDialogBodyState
    extends State<_TimeTableBarberDialogBody> {
  _TimeTableEmployeeDialogState state = _TimeTableEmployeeDialogState.initial;

  String selectedHourFrom = "8";
  String selectedMinuteFrom = "00";
  String selectedHourTo = "22";
  String selectedMinuteTo = "00";

  DateTime timeFrom = DateTime.now();
  DateTime timeTo = DateTime.now();

  @override
  void initState() {
    timeFrom = timeFrom.copyWith(
        hour: int.parse(selectedHourFrom),
        minute: int.parse(selectedMinuteFrom));
    timeTo = timeFrom.copyWith(
        hour: int.parse(selectedHourTo), minute: int.parse(selectedMinuteTo));

    final lastFilterOrderDateTime = DateTime.tryParse(
        BlocProvider.of<OrderFilterCubit>(context).state.query);

    if (lastFilterOrderDateTime != null) {
      timeFrom = timeFrom.copyWith(
          day: lastFilterOrderDateTime.day,
          month: lastFilterOrderDateTime.month,
          hour: int.parse(selectedHourFrom),
          minute: int.parse(selectedMinuteFrom));
      timeTo = timeTo.copyWith(
          day: lastFilterOrderDateTime.day,
          month: lastFilterOrderDateTime.month,
          hour: int.parse(selectedHourTo),
          minute: int.parse(selectedMinuteTo));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: Responsive.isDesktop(context)
            ? 100
            : MediaQuery.of(context).size.width,
      ),
      child: _body(),
    );
  }

  _body() {
    switch (state) {
      case _TimeTableEmployeeDialogState.initial:
        return _initialBody();
      case _TimeTableEmployeeDialogState.selectNotWorkingTIme:
        return _selectNotWorkingHours();

      case _TimeTableEmployeeDialogState.another:
        return const SizedBox();
    }
  }

  _changeState(_TimeTableEmployeeDialogState newState) =>
      setState(() => state = newState);

  _initialBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          child: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 10),
        ButtonWidget(
          text: 'selectNotWorkingTime'.tr(),
          onPressed: () =>
              _changeState(_TimeTableEmployeeDialogState.selectNotWorkingTIme),
          color: const Color(0xffef906e),
        ),
        const SizedBox(height: 10),
        ButtonWidget(
          text: 'changeSchedule'.tr(),
          onPressed: () {
            Navigator.pop(context);
            widget.onChangeEmployeeSchedule.call();
          },
          color: const Color(0xff95f132),
        ),
        const SizedBox(height: 10),
        ButtonWidget(
          text: 'removeFromTimeTable'.tr(),
          onPressed: () {
            widget.onDeleteEmployeeFromTable.call();
            Navigator.pop(context);
          },
          color: Colors.blue,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  _selectNotWorkingHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 33),
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
                    timeFrom = timeFrom.copyWith(
                        hour: int.parse(selectedHourFrom), minute: 0);

                    print("Time from $timeFrom");
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
                    timeFrom = timeFrom.copyWith(
                        minute: int.parse(selectedMinuteFrom));
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
                    timeTo = timeTo.copyWith(
                        hour: int.parse(selectedHourTo), minute: 0);
                    print("Time to $timeTo");
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
                    timeTo =
                        timeTo.copyWith(minute: int.parse(selectedMinuteTo));
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  text: 'exit'.tr(),
                  onPressed: () =>
                      _changeState(_TimeTableEmployeeDialogState.initial),
                  color: const Color(0xffABACAE),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ButtonWidget(
                  text: 'save'.tr(),
                  onPressed: () {
                    widget.onTimeSelected.call(timeFrom, timeTo);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  color: const Color(0xffABACAE),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
