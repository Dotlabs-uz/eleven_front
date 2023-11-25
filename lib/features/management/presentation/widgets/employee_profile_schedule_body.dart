import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/error_flash_bar.dart';
import '../../../../core/components/success_flash_bar.dart';
import '../../domain/entity/employee_entity.dart';
import '../../domain/entity/weekly_schedule_item_entity.dart';
import '../cubit/employee/employee_cubit.dart';
import 'profile_schedule_item_widget.dart';

class EmployeeProfileScheduleBody extends StatelessWidget {
  final EmployeeEntity  employeeEntity;
  const EmployeeProfileScheduleBody({Key? key, required this.employeeEntity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCubit, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeWeeklyScheduleSaved) {
          SuccessFlushBar("change_success".tr()).show(context);
        } else if (state is EmployeeError) {
          ErrorFlushBar("change_error".tr(args: [state.message])).show(context);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(employeeEntity.weeklySchedule.schedule.length,
                (index) {
              final WeeklyScheduleItemEntity element =
                  employeeEntity.weeklySchedule.schedule[index];

              return Column(
                children: [
                  const SizedBox(height: 10),
                  ProfileScheduleItemWidget(weeklyScheduleItemEntity: element, day: index),
                  const SizedBox(height: 10),
                  const Divider(),
                ],
              );
            }),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<EmployeeCubit>(context)
                          .saveWeeklySchedule(
                        employeeId: employeeEntity.id,
                        weeklySchedule: employeeEntity.weeklySchedule,
                      );
                    },
                    child: Text(
                      "save".tr(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

