import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'calendar_resourse_widget.dart';
import 'calendar_widget.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _ContentWidget();
  }
}

class _ContentWidget extends StatefulWidget {
  const _ContentWidget({Key? key}) : super(key: key);

  @override
  State<_ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<_ContentWidget> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: CalendarResourceWidget(),);
    // return Scaffold(
    //     body: SfCalendar(
    //   view: CalendarView.workWeek,
    //
    //   allowAppointmentResize: true,
    //   allowDragAndDrop: true,
    //
    //   dataSource: MeetingDataSource(_getDataSource()),
    //   timeSlotViewSettings: const TimeSlotViewSettings(
    //     startHour: 8,
    //     endHour: 23,
    //     nonWorkingDays: <int>[],
    //     timeInterval: Duration(minutes: 60),
    //     timeIntervalHeight: 80,
    //     timeFormat: 'h:mm',
    //     dateFormat: 'd',
    //     dayFormat: 'EEE',
    //     timeRulerSize: 70,
    //   ),
    //
    //   // allowViewNavigation: true,
    //   // showNavigationArrow: true,
    //   // showWeekNumber: true,
    //   // showCurrentTimeIndicator: true,
    //   // scheduleViewSettings: ScheduleViewSettings(),
    //   resourceViewSettings: const ResourceViewSettings(
    //     showAvatar: true,
    //     displayNameTextStyle: TextStyle(fontSize: 14, color: Colors.red),
    //     visibleResourceCount: 40,
    //   ),
    //   // dragAndDropSettings: DragAndDropSettings(
    //   // showTimeIndicator: true,allowNavigation: true,
    //   // allowScroll: true,
    //   // ),
    //
    //   onDragEnd: (appointmentDragEndDetails) {},
    //   onDragStart: (appointmentDragStartDetails) {},
    //   onDragUpdate: (appointmentDragUpdateDetails) {},
    // ));
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
      Meeting(
        'Conference',
        startTime,
        endTime,
        const Color(0xFF0F8644),
        false,
      ),
    );
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
