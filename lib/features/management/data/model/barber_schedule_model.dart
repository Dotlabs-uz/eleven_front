// ignore_for_file: must_be_immutable

import 'package:eleven_crm/features/management/data/model/not_working_hours_model.dart';
import 'package:eleven_crm/features/management/domain/entity/employee_schedule_entity.dart';

import '../../domain/entity/barber_schedule_entity.dart';

class BarberScheduleModel extends BarberScheduleEntity {
  const BarberScheduleModel({
    required super.notWorkingHours,
    required super.status,
  });

  factory BarberScheduleModel.fromJson(Map<String, dynamic> json) {
    return BarberScheduleModel(
      notWorkingHours: List.from(json['notWorkingHours'])
          .map((e) => NotWorkingHoursModel.fromJson(
                e,
              ))
          .toList(),
      status: EmployeeScheduleStatus.values[json['status']],
    );
  }

  factory BarberScheduleModel.fromEntity(BarberScheduleEntity entity) {
    return BarberScheduleModel(notWorkingHours: entity.notWorkingHours, status: entity.status);
  }

  toJson() {
    final Map<String, dynamic> data = {};

    data['notWorkingHours'] = notWorkingHours
        .map((e) => NotWorkingHoursModel.fromEntity(e).toJson())
        .toList();
    data['status'] = status.index;

    return data;
  }
}
