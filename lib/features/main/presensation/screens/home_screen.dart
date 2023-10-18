import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/utils/string_helper.dart';
import 'package:eleven_crm/features/auth/data/datasources/authentication_local_data_source.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../core/components/data_order_form.dart';
import '../../../../core/components/responsive_builder.dart';
import '../../../../get_it/locator.dart';
import '../../../management/domain/entity/employee_entity.dart';
import '../../../management/domain/entity/employee_schedule_entity.dart';
import '../../domain/entity/order_entity.dart';
import '../cubit/data_form/data_form_cubit.dart';
import '../cubit/order/order_cubit.dart';
import '../cubit/top_menu_cubit/top_menu_cubit.dart';
import '../widget/my_icon_button.dart';
import 'calendar_main_version_two_widget.dart';

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
  late AuthenticationLocalDataSource localDataSource;
  late OrderEntity activeData;
  late bool isFormVisible;

  late PlutoRow selectedRow;
  late PlutoGridStateManager stateManager;
  @override
  void initState() {
    localDataSource = locator();

    initialize();

    super.initState();
  }

  initialize() async {
    print("Saved ");

    activeData = OrderEntity.empty();

    isFormVisible = false;

    _setWidgetTop();

    await localDataSource.saveSessionId(
        "eyJhbGciOiJIUzI1NiIsInR5cCI6ImFjY2VzcyJ9.eyJ1c2VySWQiOiI2NTJjZjQ3ZGY2NTViZDdjYmExZmQ4MTUiLCJwYXRoIjoibWFuYWdlcnMiLCJpYXQiOjE2OTc0NDQ5ODksImV4cCI6MTY5NzUzMTM4OSwiYXVkIjoiaHR0cHM6Ly95b3VyZG9tYWluLmNvbSIsImlzcyI6ImZlYXRoZXJzIiwianRpIjoiOGUzMzM2NjQtMmVhZi00ZmRlLWIyYTAtMjZkN2IxNGU5MDlhIn0.D4CPUFD4_vfDCy9sCy2AM0FtDMWC2P_jTRDtmTp1nHU");
  }

  _setWidgetTop() {
    // final Map<String, dynamic> filtr = {};

    BlocProvider.of<TopMenuCubit>(context).setWidgets(
      [
        MyIconButton(
          onPressed: () {
            activeData = OrderEntity.empty();
            _editData(activeData);
          },
          icon: const Icon(Icons.add_box_rounded),
        ),
        MyIconButton(
          onPressed: () {},
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  void _saveData() {
    BlocProvider.of<OrderCubit>(context).save(order: OrderEntity.fromFields());
  }

  void _editData(OrderEntity data) {
    BlocProvider.of<DataFormCubit>(context).editData(data.getFields());

    if (ResponsiveBuilder.isMobile(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            body: DataOrderForm(
              saveData: _saveData,
              closeForm: () => Navigator.pop(context),
              fields: data.getFields(),
            ),
          ),
        ),
      );
    } else {
      setState(() => isFormVisible = true);
    }
  }

  Map<int, Widget> children = <int, Widget>{
    0: Text("Day".tr()),
    1: Text("Week".tr()),
  };

  int selectedValue = 0;

  final List<EmployeeEntity> listEmployee = [
    EmployeeEntity(
      id: "1",
      firstName: "Sam",
      lastName: "Satt",
      phoneNumber: 99,
      role: "manager",
      schedule: [
        EmployeeScheduleEntity(
          date: DateTime.now().toIso8601String(),
          status: 1,
        ),
      ],
    ),
    EmployeeEntity(
      id: "2",
      firstName: "Alex",
      lastName: "Satt",
      phoneNumber: 99,
      role: "manager",
      schedule: [
        EmployeeScheduleEntity(
          date: DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          status: 1,
        ),
      ],
    ),
    EmployeeEntity(
      id: "3",
      firstName: "FFF",
      lastName: "Satt",
      phoneNumber: 99,
      role: "manager",
      schedule: [
        EmployeeScheduleEntity(
          date: DateTime.now().add(const Duration(days: 2)).toIso8601String(),
          status: 1,
        ),
      ],
    ),
    EmployeeEntity(
      id: "4",
      firstName: "Alex",
      lastName: "Satt",
      phoneNumber: 99,
      role: "manager",
      schedule: [
        EmployeeScheduleEntity(
          date: DateTime.now().add(const Duration(days: 3)).toIso8601String(),
          status: 1,
        ),
      ],
    ),
    EmployeeEntity(
      id: "5",
      firstName: "Alex",
      lastName: "Satt",
      phoneNumber: 99,
      role: "manager",
      schedule: [
        EmployeeScheduleEntity(
          date: DateTime.now().add(const Duration(days: 4)).toIso8601String(),
          status: 1,
        ),
      ],
    ),
  ];

  _dateTimeWidget() {
    final now = DateTime.now();
    const style = TextStyle();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${now.day} ",
          style: style,
        ),
        Text(
          "${StringHelper.monthName(month: now.month).tr().toLowerCase()} ",
          style: style,
        ),
        Text(
          StringHelper.getDayOfWeekType(now).tr().toLowerCase(),
          style: style,
        ),
      ],
    );
  }

  // List<Order> orders = [
  //   Order(
  //     id: '1',
  //     startTime: DateTime(2023, 10, 7, 9, 0), // Начало заказа
  //     endTime: DateTime(2023, 10, 7, 10, 30), // Конец заказа
  //     title: 'Заказ 1', // Имя клиента или другой заголовок
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              // CupertinoSlidingSegmentedControl<int>(
              //   backgroundColor: CupertinoColors.white,
              //   thumbColor: Colors.grey,
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   groupValue: selectedValue,
              //   children: children,
              //   onValueChanged: (value) {
              //     if (value != null) {
              //       setState(() {
              //         selectedValue = value;
              //       });
              //     }
              //   },
              // ),
              Expanded(child: _dateTimeWidget()),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // const Expanded(
                //     child: CalendarWidget(
                //   calendarsCount: 3,
                // )),

                Expanded(
                  flex: 2,
                  child:
                      CalendarMainVersionTwoWidget(listEmployee: listEmployee),
                ),
                if (isFormVisible)
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: DataOrderForm(
                        fields: activeData.getFields(),
                        closeForm: () => setState(() => isFormVisible = false),
                      ),
                    ),
                  ),
                if (!isFormVisible) const SizedBox(width: 5),
                if (!isFormVisible)
                  Card(
                    shadowColor: Colors.transparent,
                    margin: EdgeInsets.zero,
                    child: Container(
                      width: 120,
                      color: const Color(0xffe0e0e0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 20),
                          ...List.generate(listEmployee.length, (index) {
                            final el = listEmployee[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${el.firstName} ${el.lastName}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
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
