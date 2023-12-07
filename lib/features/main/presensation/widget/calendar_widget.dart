import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hive/hive.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/services/web_sockets_service.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/string_helper.dart';

class CalendarWidget extends StatefulWidget {
  final Function() onRefreshTap;
  final Function(DateTime dateTime) onDateTap;
  final List<DateTime> listBlinkDates;
  const CalendarWidget(
      {Key? key,
      required this.onRefreshTap,
      required this.onDateTap,
      required this.listBlinkDates})
      : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final List<int?> daysOfMonth = [];

  bool viewWaitText = false;
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
  final WebSocketsService webSocketService =
      WebSocketsService(ApiConstants.ordersWebSocket);

  static List<DateTime> listBlinkedDates = [];
  static final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer()
    ..open(
      Audio.file(Assets.tNewOrderVoiceAirport),
      volume: 0,
      loopMode: LoopMode.none,
      forceOpen: true,
    );

  @override
  void didUpdateWidget(covariant CalendarWidget oldWidget) {
    if (listBlinkedDates.length != widget.listBlinkDates.length) {
      _voice();
      listBlinkedDates = widget.listBlinkDates;
    }
    super.didUpdateWidget(oldWidget);
  }

  _voice() async {
    try {
      if (assetsAudioPlayer.isPlaying.value == true) return;
      print("Voice ");

      assetsAudioPlayer.play();
    } catch (error) {
      print("Error voice $error");
      //mp3 unreachable
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
initialize();
    super.initState();
  }

  initialize() async {
    listBlinkedDates.clear();
    _initDaysOfMonth();
    final authenticationBox = await Hive.openBox('authenticationBox');
    final token = await authenticationBox.get('session_id');
    webSocketService.connect(token);
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
      child: StreamBuilder<dynamic>(
        stream: webSocketService.getDatesResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final listSnapData = List.from(snapshot.data);

            print("$listSnapData Dates");
            if (listSnapData.isNotEmpty) {
              final data = listSnapData
                  .map((e) => DateFormat("yyyy-MM-dd").parse(e))
                  .toList();

              if(listBlinkedDates.length != listSnapData.length) {
                _voice();
              }
              listBlinkedDates = data;
            }
          }

          return Column(
            children: [
              _monthSelector(),
              const SizedBox(height: 10),
              _datesSelection(listBlinkedDates),
            ],
          );
        },
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
          onPressed: () {
            final now = DateTime.now();
            selectedDate = now;
            setState(() {});
            widget.onRefreshTap.call();
          },
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

  _datesSelection(List<DateTime> localBlinked) {
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
              listBlinkedDates: localBlinked,
              month: selectedMonth,
              year: currentYear,
              onDateTap: (dateTime) {
                if (day != null) {
                  selectedDate = DateTime(currentYear, selectedMonth, day);

                  viewWaitText = true;
                  setState(() {});
                  localBlinked.remove(dateTime);
                  listBlinkedDates.remove(dateTime);
                  widget.onDateTap.call(selectedDate);
                }
              },
            );
          },
        ),

        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),

          child: viewWaitText ?  _WaitText(onTimerEnd: () {
            print("wait text");
            viewWaitText = false;
            setState(() {

            });
          },) : SizedBox(),
        ),


      ],
    );
  }
}

class _WaitText extends StatefulWidget {
  final Function() onTimerEnd;
  const _WaitText({Key? key, required this.onTimerEnd}) : super(key: key);

  @override
  State<_WaitText> createState() => _WaitTextState();
}

class _WaitTextState extends State<_WaitText> {

  @override
  void initState() {
    initialize() ;
    super.initState();
  }

  initialize()   {


       Timer(const Duration(seconds: 4), () {
         widget.onTimerEnd.call();
       },);

  }
  @override
  Widget build(BuildContext context) {
    return Text("pleaseWaitFilterIsInProcess".tr(), style: const TextStyle(
      fontFamily: "Nunito",
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,

    ),);
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
  List<DateTime> listBlinkedDates = [];
  late StreamController<int> _streamController;

  @override
  void dispose() {
    _streamController.close(); // Закрытие контроллера потока

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _DayItem oldWidget) {
    if (month != widget.month) {
      month = widget.month;
    }
    if ((listBlinkedDates.length != widget.listBlinkedDates.length)) {
      listBlinkedDates = widget.listBlinkedDates;
      _startBlinking();
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
    _streamController = StreamController();
    _startBlinking();
  }

  void _startBlinking() async {
    if (widget.day == null) return;

    final dt = DateTime(widget.year, month, widget.day!);

    final condition = listBlinkedDates.contains(dt);

    if (_streamController.isClosed == false &&
        (condition && widget.selectedDate != dt)) {
      if(_streamController.hasListener == false) {
        _startTimer(10000000);
      }
      _streamController.stream.listen((value) {
        setState(() {
          backgroundColor = value % 2 == 0 ? Colors.purple : null;
        });
      });
    } else {
      backgroundColor = null;
      _streamController.onPause;
      setState(() {});
    }
  }

  _startTimer(int duration) async {
    if(_streamController.isClosed) return;
    for (var i = 0; i < duration; i++) {
      await Future.delayed(const Duration(seconds: 1));
      _streamController.add(i);
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
            final dt = DateTime(widget.year, widget.month, widget.day!);
            listBlinkedDates.remove(dt);
            _streamController.close();
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
                        ?
                 AppColors.accent

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
                      color: backgroundColor != null
                          ? Colors.white
                          : widget.isSelectedDate
                              ? Colors.white
                              : widget.isCurrentDate
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
