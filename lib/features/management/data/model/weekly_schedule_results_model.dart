// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../domain/entity/weekly_schedule_results_entity.dart';
import 'weekly_schedule_item_model.dart';

@immutable
class WeeklyScheduleResultsModel extends WeeklyScheduleResultsEntity {
  const WeeklyScheduleResultsModel({required super.schedule});

  factory WeeklyScheduleResultsModel.fromJson(List<dynamic> data) {
    return WeeklyScheduleResultsModel(
        schedule: data.map((e) => WeeklyScheduleItemModel.fromJson(e)).toList());
  }

  factory WeeklyScheduleResultsModel.fromEntity(WeeklyScheduleResultsEntity entity) {
    return WeeklyScheduleResultsModel(
      schedule: entity.schedule,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['weeklySchedule'] = schedule
        .map((e) => WeeklyScheduleItemModel.fromEntity(e).toJson())
        .toList();

    return data;
  }
}
