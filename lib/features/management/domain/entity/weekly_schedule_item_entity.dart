// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'employee_schedule_entity.dart';
import 'working_hours_for_barber_schedule_entity.dart';

@immutable
class WeeklyScheduleItemEntity extends Equatable {
  final List<NotWorkingHoursForWeeklyScheduleEntity> workingHours;
  late   EmployeeScheduleStatus status;

    WeeklyScheduleItemEntity({
    required this.workingHours,
    required this.status,
  });

  @override
  List<Object?> get props => [status];
}
