import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/components/datetime_for_table_widget.dart';
import '../../../../core/entities/field_entity.dart';
import 'employee_entity.dart';

class EmployeeScheduleEntity extends Equatable {

  final EmployeeEntity employee;
  final List status;

  const EmployeeScheduleEntity({
    required this.employee,
    required this.status,
  });

  factory EmployeeScheduleEntity.empty() {
    return  EmployeeScheduleEntity(
      employee: EmployeeEntity.empty(),
      status: [],
    );
  }

  @override
  List<Object?> get props => [employee, status];
}
