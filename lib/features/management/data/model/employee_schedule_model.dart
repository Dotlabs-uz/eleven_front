// ignore_for_file: must_be_immutable

import '../../domain/entity/employee_schedule_entity.dart';

class EmployeeScheduleModel extends EmployeeScheduleEntity {
  EmployeeScheduleModel({
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.employee,
    // required super.rest,
  });

  factory EmployeeScheduleModel.fromJson(Map<String, dynamic> json) {
    return EmployeeScheduleModel(
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
      employee: json['employee'],
      // rest: List.from(json['rest'])
      //     .map((e) => EmployeeScheduleRestModel.fromJson(e))
      //     .toList(),
    );
  }

  factory EmployeeScheduleModel.fromEntity(EmployeeScheduleEntity entity) {
    return EmployeeScheduleModel(
      startTime: entity.startTime,
      endTime: entity.endTime,
      status: entity.status,
      employee: entity.employee,
      // rest: entity.rest,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['status'] = status;
    data['employee'] = employee;
    // data['rest'] = rest;
    return data;
  }
}
