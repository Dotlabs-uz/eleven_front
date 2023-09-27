import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/components/datetime_for_table_widget.dart';
import '../../../../core/entities/field_entity.dart';
import 'employee_entity.dart';

class EmployeeScheduleRestEntity extends Equatable {

  final String startTime;
  final String endTime;

  const EmployeeScheduleRestEntity({
    required this.startTime,
    required this.endTime,
  });

  factory EmployeeScheduleRestEntity.empty() {
    return   EmployeeScheduleRestEntity(
      startTime: DateTime.now().toIso8601String(),
      endTime: DateTime.now().toIso8601String(),
    );
  }

  @override
  List<Object?> get props => [ startTime, endTime,];
}

