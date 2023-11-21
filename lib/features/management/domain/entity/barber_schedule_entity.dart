// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/components/datetime_for_table_widget.dart';
import '../../../../core/entities/field_entity.dart';
import '../../../products/domain/entity/filial_entity.dart';
import 'employee_schedule_entity.dart';
import 'not_working_hours_entity.dart';

@immutable
class BarberScheduleEntity extends Equatable {
  final List<NotWorkingHoursEntity> notWorkingHours;
  final EmployeeScheduleStatus status;

  const BarberScheduleEntity({
    required this.notWorkingHours,
    required this.status,
  });

  @override
  List<Object?> get props => [status];
}
