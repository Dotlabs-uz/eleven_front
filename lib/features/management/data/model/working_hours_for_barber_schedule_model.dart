// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../domain/entity/working_hours_for_barber_schedule_entity.dart';

@immutable
class WorkingHoursForWeeklyScheduleModel
    extends NotWorkingHoursForWeeklyScheduleEntity {
  WorkingHoursForWeeklyScheduleModel({
    required super.dateFrom,
    required super.dateTo,
  });

  factory WorkingHoursForWeeklyScheduleModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WorkingHoursForWeeklyScheduleModel(
      dateFrom: DateTime.parse(json['from']),
      dateTo: DateTime.parse(json['to']),
    );
  }

  factory WorkingHoursForWeeklyScheduleModel.fromEntity(
      NotWorkingHoursForWeeklyScheduleEntity entity) {
    return WorkingHoursForWeeklyScheduleModel(
      dateFrom: entity.dateFrom,
      dateTo: entity.dateTo,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['from'] = dateFrom.toIso8601String();
    data['to'] = dateTo.toIso8601String();
    return data;
  }
}
