// ignore_for_file: must_be_immutable

import '../../domain/entity/employee_schedule_entity.dart';

class EmployeeScheduleModel extends EmployeeScheduleEntity {
  EmployeeScheduleModel({
    required super.date,
    required super.status,
    required super.employee,
    // required super.rest,
  });

  factory EmployeeScheduleModel.fromJson(Map<String, dynamic> json) {
    return EmployeeScheduleModel(
      date: json['date'],
      status: json['status'],
      employee: json['employee'],
      // rest: List.from(json['rest'])
      //     .map((e) => EmployeeScheduleRestModel.fromJson(e))
      //     .toList(),
    );
  }

  factory EmployeeScheduleModel.fromEntity(EmployeeScheduleEntity entity) {
    return EmployeeScheduleModel(
      date: entity.date,
      status: entity.status,
      employee: entity.employee,
      // rest: entity.rest,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['date'] = date;
    data['status'] = status;
    data['employee'] = employee;
    // data['rest'] = rest;
    return data;
  }
}
