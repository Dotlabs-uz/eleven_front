import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarResourceWidget extends StatefulWidget {
  const CalendarResourceWidget({Key? key}) : super(key: key);

  @override
  State<CalendarResourceWidget> createState() => _CalendarResourceWidgetState();
}

class _CalendarResourceWidgetState extends State<CalendarResourceWidget> {
  List<Appointment> _shiftCollection = <Appointment>[];
  final List<CalendarResource> _employeeCollection = <CalendarResource>[];
  late _DataSource _events;

  @override
  void initState() {
    _addResources();
    _addAppointments();
    _events = _DataSource(_shiftCollection, _employeeCollection);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.timelineWeek,
      allowedViews: const [
        CalendarView.timelineDay,
        CalendarView.timelineWeek,
        CalendarView.timelineWorkWeek,
      ],
      showDatePickerButton: true,
      allowAppointmentResize: true,
      allowDragAndDrop: true,
      dragAndDropSettings: const DragAndDropSettings(
        showTimeIndicator: true,
      ),
      appointmentBuilder: (context, calendar) {
        // print(calendar.appointments.first.toString());
        final Appointment appointment = calendar.appointments.first;
        return Container(
          color: Colors.red,
          child: Text(
              ("${appointment.startTime.hour}:${appointment.startTime.minute}/${appointment.endTime.hour}:${appointment.endTime.minute}")),
        );
      },
      resourceViewSettings: const ResourceViewSettings(
        // displayNameTextStyle: TextStyle(color: Colors.white),
        showAvatar: true,
        // size: 120,
        // visibleResourceCount: 2,
      ),
      dataSource: _events,
    );
  }

  void _addResources() {
    List<String> nameCollection = <String>[];
    nameCollection.add('John');
    nameCollection.add('Bryan');
    nameCollection.add('Robert');
    nameCollection.add('Kenny');

    for (int i = 0; i < nameCollection.length; i++) {
      _employeeCollection.add(CalendarResource(
        displayName: nameCollection[i],
        id: '000$i',
        // image: const NetworkImage(
        //   "https://c4.wallpaperflare.com/wallpaper/142/751/831/landscape-anime-digital-art-fantasy-art-wallpaper-thumb.jpg",
        // ),
        color: Colors.grey,
      ));
    }
  }

  void _addAppointments() {
    _shiftCollection = <Appointment>[];
    List<String> subjectCollection = <String>[];
    subjectCollection.add('General Meeting');
    subjectCollection.add('Plan Execution');
    subjectCollection.add('Project Plan');
    subjectCollection.add('Consulting');

    final Random random = Random();
    for (int i = 0; i < _employeeCollection.length; i++) {
      final List<String> employeeIds = <String>[
        _employeeCollection[i].id.toString()
      ];
      _shiftCollection.add(
        Appointment(
          startTime: DateTime.now(),
          endTime: DateTime.now().add(Duration(hours: 1 + i)),
          subject: subjectCollection[random.nextInt(4)],
          color: Colors.green,
          resourceIds: employeeIds,
        ),
      );
    }
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}
