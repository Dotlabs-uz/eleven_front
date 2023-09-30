import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/management/domain/entity/employee_schedule_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/components/data_form.dart';
import '../../../../get_it/locator.dart';
import '../../../main/presensation/cubit/top_menu_cubit/top_menu_cubit.dart';
import '../../../main/presensation/widget/my_icon_button.dart';
import '../../domain/entity/employee_entity.dart';
import '../cubit/employee_schedule/employee_schedule_cubit.dart';
import '../widgets/employee_schedule_status_widget.dart';
import '../widgets/employee_schedule_widget.dart';

class EmployeeScheduleScreen extends StatefulWidget {
  const EmployeeScheduleScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeScheduleScreen> createState() => _EmployeeScheduleScreenState();
}

class _EmployeeScheduleScreenState extends State<EmployeeScheduleScreen> {
  late EmployeeScheduleCubit employeeScheduleCubit;

  @override
  void initState() {
    employeeScheduleCubit = locator<EmployeeScheduleCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeeScheduleCubit>(
          create: (context) => employeeScheduleCubit,
        ),
      ],
      child: ContentWidget(
        employeeScheduleCubit: employeeScheduleCubit,
      ),
    );
  }
}

class ContentWidget extends StatefulWidget {
  final EmployeeScheduleCubit employeeScheduleCubit;

  const ContentWidget({
    Key? key,
    required this.employeeScheduleCubit,
  }) : super(key: key);

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  late bool isFormVisible;
  bool isSearch = false;
  static int dataCount = 0;
  static int pageCount = 0;
  final GlobalKey<DataFormWidgetState> _formKey = GlobalKey();
  late List<EmployeeEntity> customers;
  late EmployeeEntity activeData;

  late List<PlutoRow> selectedRows;
  late List<PlutoRow> rows;
  late PlutoRow selectedRow;
  late PlutoGridStateManager stateManager;

  var filter = "";

  void _saveData() {
    BlocProvider.of<EmployeeScheduleCubit>(context).save();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    BlocProvider.of<EmployeeScheduleCubit>(context).load();
    _setWidgetTop();
  }

  _setWidgetTop() {
    // final Map<String, dynamic> filtr = {};

    BlocProvider.of<TopMenuCubit>(context).setWidgets(
      [
        MyIconButton(
          onPressed: () => setState(() => isSearch = !isSearch),
          icon: const Icon(Icons.search),
        ),
        MyIconButton(
          onPressed: () {},
          icon: const Icon(Icons.add_box_rounded),
        ),
        MyIconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.filter_alt,
          ),
        ),
        MyIconButton(
            onPressed: () {
              BlocProvider.of<EmployeeScheduleCubit>(context).load();
            },
            icon: const Icon(Icons.refresh)),
      ],
    );
  }

  initCubit() => BlocProvider.of<EmployeeScheduleCubit>(context).init();

  final List<EmployeeEntity> listEmployee = [
    EmployeeEntity(
      id: 1,
      fullName: "Sam",
      createdAt: DateTime.now().toIso8601String(),
      phoneNumber: "",
      shopName: "",
      schedule: [
        EmployeeScheduleEntity(
          startTime: DateTime.now().toIso8601String(),
          endTime: DateTime.now().toIso8601String(),
          status: 1,
        ),
      ],
    ),
    EmployeeEntity(
      id: 2,
      fullName: "Alex",
      createdAt: DateTime.now().toIso8601String(),
      phoneNumber: "",
      shopName: "",
      schedule: [
        EmployeeScheduleEntity(
          startTime:
              DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          endTime: DateTime.now().toIso8601String(),
          status: 1,
        ),
      ],
    ),
    EmployeeEntity(
      id: 3,
      fullName: "Dima",
      createdAt: DateTime.now().toIso8601String(),
      phoneNumber: "",
      shopName: "",
      schedule: [
        EmployeeScheduleEntity(
          startTime:
              DateTime.now().add(const Duration(days: 2)).toIso8601String(),
          endTime:
              DateTime.now().add(const Duration(days: 2)).toIso8601String(),
          status: 1,
        ),
      ],
    ),
    EmployeeEntity(
      id: 4,
      fullName: "Ali",
      createdAt: DateTime.now().toIso8601String(),
      phoneNumber: "",
      shopName: "",
      schedule: [
        EmployeeScheduleEntity(
          startTime:
              DateTime.now().add(const Duration(days: 3)).toIso8601String(),
          endTime:
              DateTime.now().add(const Duration(days: 3)).toIso8601String(),
          status: 1,
        ),
      ],
    ),
    EmployeeEntity(
      id: 5,
      fullName: "Peter",
      createdAt: DateTime.now().toIso8601String(),
      phoneNumber: "",
      shopName: "",
      schedule: [
        EmployeeScheduleEntity(
          startTime:
              DateTime.now().add(const Duration(days: 4)).toIso8601String(),
          endTime:
              DateTime.now().add(const Duration(days: 4)).toIso8601String(),
          status: 1,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                // SizedBox(
                //   height: 40,
                //   child: Row(
                //     children: <Widget>[
                //       const SizedBox(
                //         width: 120,
                //         child: Placeholder(),
                //       ),
                //       const SizedBox(width: 20),
                //       const SizedBox(
                //         width: 120,
                //         child: Placeholder(),
                //       ),
                //       const SizedBox(width: 20),
                //       ElevatedButton(
                //         onPressed: () {},
                //         child: const Text("Filter"),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      EmployeeScheduleWidget(
                        onSave: (listFields) {
                          debugPrint("List fields ${listFields.length}");

                          for (var element in listFields) {

                            debugPrint(
                                "Day ${element.dateTime.day}, Month ${element.dateTime.month}, Status ${element.status}, Employee ${element.employee}");
                          }
                        }, listEmployee: listEmployee,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const EmployeeScheduleStatusWidget(),
              ],
            ),
          ),
          // const EmployeeScheduleStatusWidget(),
        ],
      ),
    );
  }
}
