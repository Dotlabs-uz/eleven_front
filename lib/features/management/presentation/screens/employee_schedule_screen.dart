import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/loading_circle.dart';
import 'package:eleven_crm/features/management/presentation/provider/cross_in_employee_schedule_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

import '../../../../core/components/error_flash_bar.dart';
import '../../../../core/components/success_flash_bar.dart';
import '../../../../get_it/locator.dart';
import '../../../main/domain/entity/top_menu_entity.dart';
import '../../../main/presensation/cubit/top_menu_cubit/top_menu_cubit.dart';
import '../../domain/entity/employee_entity.dart';
import '../cubit/employee/employee_cubit.dart';
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
  late EmployeeCubit employeeCubit;
  late CrossInEmployeeScheduleProvider crossInEmployeeScheduleProvider;

  @override
  void initState() {
    employeeScheduleCubit = locator<EmployeeScheduleCubit>();
    employeeCubit = locator<EmployeeCubit>();
    crossInEmployeeScheduleProvider = locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeeScheduleCubit>(
          create: (context) => employeeScheduleCubit,
        ),
        BlocProvider<EmployeeCubit>(
          create: (context) => employeeCubit,
        ),
        ChangeNotifierProvider(create: (context) => crossInEmployeeScheduleProvider),
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
  final ScrollController scrollController = ScrollController();
  late List<EmployeeEntity> customers;
  late EmployeeEntity activeData;

  late List<PlutoRow> selectedRows;
  late List<PlutoRow> rows;
  late PlutoRow selectedRow;
  late PlutoGridStateManager stateManager;

  var filter = "";

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {

    BlocProvider.of<EmployeeCubit>(context).load("");
    _setWidgetTop();
  }

  _setWidgetTop() {
    BlocProvider.of<TopMenuCubit>(context).setWidgets(
      TopMenuEntity.empty(),
      // TopMenuEntity(
      //   searchCubit: widget.employeeScheduleCubit,
      //   iconList: [
      //     MyIconButton(
      //       onPressed: () => setState(() => isSearch = !isSearch),
      //       icon: const Icon(Icons.search),
      //     ),
      //     MyIconButton(
      //       onPressed: () {},
      //       icon: const Icon(Icons.add_box_rounded),
      //     ),
      //     MyIconButton(
      //       onPressed: () {},
      //       icon: const Icon(
      //         Icons.filter_alt,
      //       ),
      //     ),
      //     MyIconButton(
      //       onPressed: () {
      //         BlocProvider.of<EmployeeCubit>(context).load();
      //       },
      //       icon: const Icon(Icons.refresh),
      //     ),
      //   ],
      // ),
    );
  }

  initCubit() => BlocProvider.of<EmployeeScheduleCubit>(context).init();

  List<EmployeeEntity> listEmployee = [
    // EmployeeEntity(
    //   id: "",
    //   firstName: "Sam",
    //   lastName: "Satt",
    //   password: "Satt",
    //   login: "Satt",
    //   phoneNumber: 99,
    //   role: "manager",
    //   schedule: [
    //     EmployeeScheduleEntity(
    //       date: DateTime.now().toIso8601String(),
    //       status: 1,
    //     ),
    //   ],
    // ),
    // EmployeeEntity(
    //   id: "",
    //   firstName: "Alex",
    //   lastName: "Satt",
    //   password: "Satt",
    //   login: "Satt",
    //   phoneNumber: 99,
    //   role: "manager",
    //   schedule: [
    //     EmployeeScheduleEntity(
    //       date: DateTime.now().add(const Duration(days: 1)).toIso8601String(),
    //       status: 1,
    //     ),
    //   ],
    // ),
    // EmployeeEntity(
    //   id: "",
    //   firstName: "FFF",
    //   lastName: "Satt",
    //   password: "Satt",
    //   login: "Satt",
    //   phoneNumber: 99,
    //   role: "manager",
    //   schedule: [
    //     EmployeeScheduleEntity(
    //       date: DateTime.now().add(const Duration(days: 2)).toIso8601String(),
    //       status: 1,
    //     ),
    //   ],
    // ),
    // EmployeeEntity(
    //   id: "",
    //   firstName: "Alex",
    //   password: "Satt",
    //   login: "Satt",
    //   lastName: "Satt",
    //   phoneNumber: 99,
    //   role: "manager",
    //   schedule: [
    //     EmployeeScheduleEntity(
    //       date: DateTime.now().add(const Duration(days: 3)).toIso8601String(),
    //       status: 1,
    //     ),
    //   ],
    // ),
    // EmployeeEntity(
    //   id: "",
    //   firstName: "Alex",
    //   lastName: "Satt",
    //   password: "Satt",
    //   login: "Satt",
    //   phoneNumber: 99,
    //   role: "manager",
    //   schedule: [
    //     EmployeeScheduleEntity(
    //       date: DateTime.now().add(const Duration(days: 4)).toIso8601String(),
    //       status: 1,
    //     ),
    //   ],
    // ),
  ];



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            MultiBlocListener(
              listeners: [
                BlocListener<EmployeeScheduleCubit,
                    EmployeeScheduleState>(
                  listener: (context, state) {
                    if (state is EmployeeScheduleSaved) {
                      SuccessFlushBar("change_success".tr())
                          .show(context);
                      BlocProvider.of<EmployeeCubit>(context)
                          .load("");
                    } else if (state is EmployeeScheduleError) {
                      ErrorFlushBar("change_error"
                          .tr(args: [state.message])).show(context);
                    }
                  },
                ),
                BlocListener<EmployeeCubit, EmployeeState>(
                  listener: (context, state) {
                    if (state is EmployeeSaved) {
                      SuccessFlushBar("change_success".tr())
                          .show(context);

                      BlocProvider.of<EmployeeCubit>(context)
                          .load("");
                    } else if (state is EmployeeError) {
                      ErrorFlushBar("change_error"
                          .tr(args: [state.message])).show(context);
                    }
                  },
                ),
              ],
              child: BlocBuilder<EmployeeCubit, EmployeeState>(
                builder: (context, state) {
                  if (state is EmployeeLoaded) {
                    listEmployee = state.data;
                  }else if (state is EmployeeLoading) {
                    return const LoadingCircle();
                  }

                  return EmployeeScheduleWidget(
                    onSave: (listFields) {
                      // debugPrint("List fields ${listFields.length}");
                      //
                      // for (var element in listFields) {
                      //   debugPrint(
                      //       "Day ${element.dateTime.day}, Month ${element.dateTime.month}, Status ${element.status}, Employee ${element.employeeId}");
                      // }

                      if (listFields.isNotEmpty) {
                        BlocProvider.of<EmployeeScheduleCubit>(
                            context)
                            .save(listData: listFields);

                        listFields.clear();
                      }
                    },
                    onMultiSelectSave: (listMultiSelect) {
                      if (listMultiSelect.isNotEmpty) {
                        BlocProvider.of<EmployeeScheduleCubit>(
                            context)
                            .save(listData: listMultiSelect);

                        listMultiSelect.clear();
                      }
                    },
                    listEmployee: listEmployee,
                  );
                },
              ),
            ),
            const EmployeeScheduleStatusWidget(),
          ],
        ),
      ),
    );
  }
}
