// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

import '../../../../core/utils/constants.dart';

enum EmployeeScheduleStatus {
  notWork,
  work,
}

class EmployeeScheduleEntity extends Equatable {
  final String date;
  int status;
  final String employee;
  final Map<String, dynamic> workingHours;
  // final List<EmployeeScheduleRestEntity> rest;

  EmployeeScheduleEntity({
    required this.date,
    this.status = 0,
    this.employee = "",
    required this.workingHours,
    // required this.rest,
  });

  factory EmployeeScheduleEntity.empty() {
    return EmployeeScheduleEntity(
      date: '',
      // rest: [],
      status: 0,
      employee: "",
      workingHours: {
        "from": "${Constants.startWork.toInt()}:00",
        "to": "${Constants.endWork.toInt()}:00"
      },
    );
  }
  factory EmployeeScheduleEntity.emptyWithCustomValue(
      EmployeeScheduleEntity entity) {
    return EmployeeScheduleEntity(
      date: entity.date,
      status: entity.status,
      employee: entity.employee,
      workingHours: entity.workingHours,
    );
  }

  @override
  List<Object?> get props => [status];
}
