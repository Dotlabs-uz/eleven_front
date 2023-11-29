import 'package:eleven_crm/core/utils/constants.dart';
import 'package:flutter/material.dart';

class TimeTableRulerWidget extends StatelessWidget {
  final DateTime timeFrom;
  final DateTime timeTo;

  const TimeTableRulerWidget(
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

      final lastCurrentTime = currentTime;
      currentTime = currentTime.add(const Duration(hours: 1));
      if (timeTo.hour >= currentTime.hour) {
        timeSlots.add(_buildTimeMinuteSlot(lastCurrentTime));
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
            '${time.hour}:00',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            height: 1,
            width: 20,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeMinuteSlot(DateTime time) {
    return Container(
      height: 50, // Высота слота времени
      color: Colors.transparent,
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "${time.hour}:30",
            style: TextStyle(
              fontSize: 8,
              color: Colors.grey.shade500,

              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),

          Container(
            height: 1,
            width: 5,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}
