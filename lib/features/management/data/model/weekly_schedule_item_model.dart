// ignore_for_file: must_be_immutable

import 'package:eleven_crm/features/management/data/model/working_hours_for_barber_schedule_model.dart';
import 'package:eleven_crm/features/management/domain/entity/employee_schedule_entity.dart';

import '../../domain/entity/weekly_schedule_item_entity.dart';

class WeeklyScheduleItemModel extends WeeklyScheduleItemEntity {
   WeeklyScheduleItemModel({
    required super.workingHours,
    required super.status,
  });

  factory WeeklyScheduleItemModel.fromJson(Map<String, dynamic> json) {
    return WeeklyScheduleItemModel(
      workingHours: List.from(json['workingHours'])
          .map((e) => WorkingHoursForWeeklyScheduleModel.fromJson(e))
          .toList(),
      status: EmployeeScheduleStatus.values[json['status']],
    );
  }

  factory WeeklyScheduleItemModel.fromEntity(WeeklyScheduleItemEntity entity) {
    return WeeklyScheduleItemModel(
        workingHours: entity.workingHours, status: entity.status);
  }

  toJson() {
    final Map<String, dynamic> data = {};

    data['workingHours'] = workingHours
        .map(
            (e) => WorkingHoursForWeeklyScheduleModel.fromEntity(e).toJson())
        .toList();
    data['status'] = status.index;

    return data;
  }


  @override
  String toString() {
    return "Status $status, working hours ${workingHours.map((e) => e).toList()}";
  }
}
