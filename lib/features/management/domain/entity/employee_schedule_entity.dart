// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

enum EmployeeScheduleStatus {
  notWork,
  work,
}

class EmployeeScheduleEntity extends Equatable {
  final String date;
  int status;
  final String employee;
  // final List<EmployeeScheduleRestEntity> rest;

  EmployeeScheduleEntity({
    required this.date,
    this.status = 0,
    this.employee = "",
    // required this.rest,
  });

  factory EmployeeScheduleEntity.empty() {
    return EmployeeScheduleEntity(
      date: '',
      // rest: [],
      status: 0,
      employee: "",
    );
  }
  factory EmployeeScheduleEntity.emptyWithCustomValue(
      EmployeeScheduleEntity entity) {
    return EmployeeScheduleEntity(
      date: entity.date,
      status: entity.status,
      employee: entity.employee,
    );
  }

  @override
  List<Object?> get props => [status];
}
