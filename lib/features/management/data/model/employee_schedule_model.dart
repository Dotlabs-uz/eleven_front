// ignore_for_file: must_be_immutable

import '../../../../core/utils/constants.dart';
import '../../domain/entity/employee_schedule_entity.dart';

class EmployeeScheduleModel extends EmployeeScheduleEntity {
  EmployeeScheduleModel({
    required super.date,
    required super.status,
    required super.employee,
    required super.workingHours,
    // required super.rest,
  });

  factory EmployeeScheduleModel.fromJson(
      Map<String, dynamic> json, String employeeId) {
    return EmployeeScheduleModel(
      date: json['date'],
      status: json['status'],
      workingHours: json["workingHours"] ??  {"from": "${Constants.startWork.toInt()}:00", "to": "${Constants.endWork.toInt()}:00"},
      employee: employeeId,
      // rest: List.from(json['rest'])
      //     .map((e) => EmployeeScheduleRestModel.fromJson(e))
      //     .toList(),
    );
  }

  factory EmployeeScheduleModel.fromEntity(EmployeeScheduleEntity entity) {
    return EmployeeScheduleModel(
      date: entity.date,
      status: entity.status,
      workingHours: entity.workingHours,
      employee: entity.employee,
      // rest: entity.rest,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['date'] = date;
    data['status'] = status;
    data['employee'] = employee;
    data['workingHours'] = workingHours;
    // data['rest'] = rest;
    return data;
  }
}
