import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/utils/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../core/components/data_order_form.dart';
import '../../../../core/components/not_selected_employee_list_widget.dart';
import '../../../../core/components/responsive_builder.dart';
import '../../../../get_it/locator.dart';
import '../../../auth/data/datasources/authentication_local_data_source.dart';
import '../../../management/domain/entity/employee_entity.dart';
import '../../../management/presentation/cubit/employee/employee_cubit.dart';
import '../../domain/entity/order_entity.dart';
import '../cubit/data_form/data_form_cubit.dart';
import '../cubit/order/not_working_hours/not_working_hours_cubit.dart';
import '../cubit/order/order_cubit.dart';
import '../cubit/top_menu_cubit/top_menu_cubit.dart';
import '../widget/my_icon_button.dart';
import 'time_table_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NotWorkingHoursCubit notWorkingHoursCubit;
  late EmployeeCubit employeeCubit;

  @override
  void initState() {
    notWorkingHoursCubit = locator();
    employeeCubit = locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => notWorkingHoursCubit),
        BlocProvider(create: (context) => employeeCubit..load()),
      ],
      child: const _ContentWidget(),
    );
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
      "eyJhbGciOiJIUzI1NiIsInR5cCI6ImFjY2VzcyJ9.eyJ1c2VySWQiOiI2NTJjZjQ3ZGY2NTViZDdjYmExZmQ4MTUiLCJwYXRoIjoibWFuYWdlcnMiLCJpYXQiOjE2OTc0NDQ5ODksImV4cCI6MTY5NzUzMTM4OSwiYXVkIjoiaHR0cHM6Ly95b3VyZG9tYWluLmNvbSIsImlzcyI6ImZlYXRoZXJzIiwianRpIjoiOGUzMzM2NjQtMmVhZi00ZmRlLWIyYTAtMjZkN2IxNGU5MDlhIn0.D4CPUFD4_vfDCy9sCy2AM0FtDMWC2P_jTRDtmTp1nHU",
    );
  }

  _setWidgetTop() {
    // final Map<String, dynamic> filtr = {};

    BlocProvider.of<TopMenuCubit>(context).setWidgets(
      [
        MyIconButton(
          onPressed: () {
            activeData = OrderEntity.empty();
            _editOrder(activeData);
          },
          icon: const Icon(Icons.add_box_rounded),
        ),
        MyIconButton(
          onPressed: () {
            BlocProvider.of<EmployeeCubit>(context).load();
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  void _saveOrder() {
    BlocProvider.of<OrderCubit>(context).save(order: OrderEntity.fromFields());
  }

  void _editOrder(OrderEntity data) {
    BlocProvider.of<DataFormCubit>(context).editData(data.getFields());

    if (ResponsiveBuilder.isMobile(context)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            body: DataOrderForm(
              saveData: _saveOrder,
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

  List<EmployeeEntity> listEmployee = [];

  // final List<EmployeeEntity> listEmployee = [
  //   EmployeeEntity(
  //     id: "1",
  //     firstName: "Sam",
  //     lastName: "Satt",
  //     password: "Satt",
  //     login: "Satt",
  //     phoneNumber: 99,
  //     role: "manager",
  //     schedule: [
  //       EmployeeScheduleEntity(
  //         date: DateTime.now().toIso8601String(),
  //         status: 1,
  //       ),
  //     ],
  //   ),
  //   EmployeeEntity(
  //     id: "2",
  //     firstName: "Alex",
  //     lastName: "Satt",
  //     password: "Satt",
  //     login: "Satt",
  //     phoneNumber: 99,
  //     role: "manager",
  //     schedule: [
  //       EmployeeScheduleEntity(
  //         date: DateTime.now().add(const Duration(days: 1)).toIso8601String(),
  //         status: 1,
  //       ),
  //     ],
  //   ),
  //   EmployeeEntity(
  //     id: "3",
  //     firstName: "FFF",
  //     lastName: "Satt",
  //     phoneNumber: 99,
  //     password: "Satt",
  //     login: "Satt",
  //     role: "manager",
  //     schedule: [
  //       EmployeeScheduleEntity(
  //         date: DateTime.now().add(const Duration(days: 2)).toIso8601String(),
  //         status: 1,
  //       ),
  //     ],
  //   ),
  //   EmployeeEntity(
  //     id: "4",
  //     firstName: "Alex",
  //     lastName: "Satt",
  //     password: "Satt",
  //     login: "Satt",
  //     phoneNumber: 99,
  //     role: "manager",
  //     schedule: [
  //       EmployeeScheduleEntity(
  //         date: DateTime.now().add(const Duration(days: 3)).toIso8601String(),
  //         status: 1,
  //       ),
  //     ],
  //   ),
  //   EmployeeEntity(
  //     id: "5",
  //     firstName: "Alex",
  //     lastName: "Satt",
  //     password: "Satt",
  //     login: "Satt",
  //     phoneNumber: 99,
  //     role: "manager",
  //     schedule: [
  //       EmployeeScheduleEntity(
  //         date: DateTime.now().add(const Duration(days: 4)).toIso8601String(),
  //         status: 1,
  //       ),
  //     ],
  //   ),
  // ];

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
      body: MultiBlocListener(
        listeners: [
          BlocListener<EmployeeCubit, EmployeeState>(
            listener: (context, state) {
              if (state is EmployeeLoaded) {
                if (mounted) {
                  Future.delayed(
                    Duration.zero,
                    () {
                      setState(() {
                        listEmployee = state.data;
                      });
                    },
                  );
                }

                BlocProvider.of<EmployeeCubit>(context).init();
              }
            },
          ),
        ],
        child: Column(
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
                    child: TimeTableWidget(
                      listEmployee: listEmployee,
                      onTimeConfirm:
                          (DateTime from, DateTime to, String employeeId) {
                        BlocProvider.of<NotWorkingHoursCubit>(context).save(
                          dateFrom: from,
                          dateTo: to,
                          employeeId: employeeId,
                        );
                      },
                    ),
                  ),
                  if (isFormVisible)
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: DataOrderForm(
                          fields: activeData.getFields(),
                          closeForm: () =>
                              setState(() => isFormVisible = false),
                        ),
                      ),
                    ),
                  if (!isFormVisible) const SizedBox(width: 5),
                  if (!isFormVisible)
                    NotSelectedEmployeeListWidget(listEmployee: listEmployee, onTap: (String employeeId) {  },),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
