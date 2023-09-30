// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/components/datetime_for_table_widget.dart';
import '../../../../core/entities/field_entity.dart';
import 'employee_entity.dart';
import 'employee_schedule_rest_entity.dart';

enum EmployeeScheduleStatus {
  notSelected,
  work,
  sick,
  vacation,
}

class EmployeeScheduleEntity extends Equatable {
  final String startTime;
  final String endTime;
  int status;
  final int employee;
  // final List<EmployeeScheduleRestEntity> rest;

  EmployeeScheduleEntity({
    required this.startTime,
    required this.endTime,
    this.status = 0,
    this.employee = 0,
    // required this.rest,
  });

  factory EmployeeScheduleEntity.empty() {
    return EmployeeScheduleEntity(
      startTime: '',
      endTime: '',
      // rest: [],
      status: 0,
      employee: 0,
    );
  }
  factory EmployeeScheduleEntity.emptyWithCustomValue(
      EmployeeScheduleEntity entity) {
    return EmployeeScheduleEntity(
      startTime: entity.startTime,
      endTime: entity.endTime,
      status: entity.status,
      employee: entity.employee,
    );
  }

  @override
  List<Object?> get props => [status];
}
