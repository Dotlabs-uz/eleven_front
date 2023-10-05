import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/components/data_employee_form.dart';
import '../../../../core/components/data_form.dart';
import '../../../../core/components/data_table_with_form_widget.dart';
import '../../../../core/components/error_flash_bar.dart';
import '../../../../core/components/loading_circle.dart';
import '../../../../core/components/page_selector_widget.dart';
import '../../../../core/components/responsive_builder.dart';
import '../../../../core/components/search_field.dart';
import '../../../../core/components/success_flash_bar.dart';
import '../../../../core/utils/hive_box_keys_constants.dart';
import '../../../../get_it/locator.dart';
import '../../../main/presensation/cubit/data_form/data_form_cubit.dart';
import '../../../main/presensation/cubit/top_menu_cubit/top_menu_cubit.dart';
import '../../../main/presensation/widget/my_icon_button.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

import '../../domain/entity/employee_entity.dart';
import '../cubit/employee/employee_cubit.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  late EmployeeCubit employeeCubit;

  @override
  void initState() {
    employeeCubit = locator<EmployeeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeeCubit>(
          create: (context) => employeeCubit,
        ),
      ],
      child: ContentWidget(
        employeeCubit: employeeCubit,
      ),
    );
  }
}

class ContentWidget extends StatefulWidget {
  final EmployeeCubit employeeCubit;

  const ContentWidget({
    Key? key,
    required this.employeeCubit,
  }) : super(key: key);

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  void _saveData() {
    BlocProvider.of<EmployeeCubit>(context)
        .save(customer: EmployeeEntity.fromFields());
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    BlocProvider.of<EmployeeCubit>(context).load();
  }

  fetch(
    int page,
  ) async {
    BlocProvider.of<EmployeeCubit>(context).load(search: "", page: page);
  }

  initCubit() {
    BlocProvider.of<EmployeeCubit>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          BlocConsumer<EmployeeCubit, EmployeeState>(
            listener: (context, state) {
              if (state is EmployeeLoaded) {
                // customers = state.data;
                // dataCount = state.dataCount;
              }

              {
                if (state is EmployeeSaved) {
                  SuccessFlushBar("change_success".tr()).show(context);
                } else if (state is EmployeeDeleted) {
                  SuccessFlushBar("data_deleted".tr()).show(context);
                } else if (state is EmployeeError) {
                  ErrorFlushBar("change_error".tr(args: [state.message]))
                      .show(context);
                }
              }
            },
            builder: (context, state) {
              if (state is EmployeeLoading) {
                return const Expanded(child: LoadingCircle());
              } else {
                if (state is EmployeeSaved) {
                  initCubit();
                } else if (state is EmployeeDeleted) {
                  initCubit();
                }
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
