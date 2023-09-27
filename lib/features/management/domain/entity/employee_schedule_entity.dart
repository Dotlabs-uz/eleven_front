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
  final int status;
  // final List<EmployeeScheduleRestEntity> rest;

  const EmployeeScheduleEntity({
    required this.startTime,
    required this.endTime,
    required this.status,
    // required this.rest,
  });

  factory EmployeeScheduleEntity.empty() {
    return const EmployeeScheduleEntity(
      startTime: '',
      endTime: '',
      // rest: [],
      status: 0,
    );
  }

  @override
  List<Object?> get props => [status];
}
