import 'package:eleven_crm/core/utils/constants.dart';
import 'package:flutter/material.dart';

class CalendarRulerWidget extends StatelessWidget {
  final DateTime timeFrom;
  final DateTime timeTo;

  const CalendarRulerWidget(
      {Key? key, required this.timeFrom, required this.timeTo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Constants.rulerWidth,

      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: _buildTimeSlots(),
        ),
      ),
    );
  }
  List<Widget> _buildTimeSlots() {
    List<Widget> timeSlots = [];

    DateTime currentTime = timeFrom;
    while (timeTo.hour >= currentTime.hour) {
      timeSlots.add(_buildTimeHourSlot(currentTime));

      currentTime = currentTime.add(const Duration(hours: 1));
      if (timeTo.hour >= currentTime.hour) {
        timeSlots.add(_buildTimeMinuteSlot(currentTime));
      }
    }

    return timeSlots;
  }

  Widget _buildTimeHourSlot(DateTime time) {
    return Container(
      height: 50, // Высота слота времени
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 0),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,

        children: [
          Text(
            '${time.hour}', // Время

            style: const TextStyle(
              fontSize: 16, // Размер шрифта времени
              color: Colors.black,
              fontWeight: FontWeight.bold, // Жирный стиль для часа
            ),
          ),
          const SizedBox(width: 5),
          Container(
            height: 1,
            width: 50,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeMinuteSlot(DateTime time) {
    return Container(
      height: 50, // Высота слота времени
      color:Colors.transparent,
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,

        children: [
          const Text(
            '30', // Время
            style: TextStyle(
              fontSize: 16, // Размер шрифта времени
              color: Colors.black,

              fontWeight: FontWeight.bold, // Жирный стиль для часа
            ),
          ),
          Container(
            height: 1,
            width: 20,
            color: Colors.black,
          ),

        ],
      ),
    );
  }
}
