// ignore_for_file: must_be_immutable

import 'package:eleven_crm/features/management/data/model/not_working_hours_for_barber_schedule_model.dart';
import 'package:eleven_crm/features/management/data/model/not_working_hours_model.dart';
import 'package:eleven_crm/features/management/domain/entity/employee_schedule_entity.dart';

import '../../domain/entity/barber_schedule_entity.dart';

class BarberScheduleModel extends BarberScheduleEntity {
  BarberScheduleModel({
    required super.workingHours,
    required super.status,
  });

  factory BarberScheduleModel.fromJson(Map<String, dynamic> json) {
    return BarberScheduleModel(
      workingHours: List.from(json['workingHours'])
          .map((e) => NotWorkingHoursForBarberScheduleModel.fromJson(e))
          .toList(),
      status: EmployeeScheduleStatus.values[json['status']],
    );
  }

  factory BarberScheduleModel.fromEntity(BarberScheduleEntity entity) {
    return BarberScheduleModel(
        workingHours: entity.workingHours, status: entity.status);
  }

  toJson() {
    final Map<String, dynamic> data = {};

    data['workingHours'] = workingHours
        .map(
            (e) => NotWorkingHoursForBarberScheduleModel.fromEntity(e).toJson())
        .toList();
    data['status'] = status.index;

    return data;
  }
}
