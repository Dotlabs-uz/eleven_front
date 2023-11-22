// ignore_for_file: must_be_immutable


import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'weekly_schedule_item_entity.dart';

@immutable
class WeeklyScheduleResultsEntity extends Equatable {
  final List<WeeklyScheduleItemEntity> schedule;

  const WeeklyScheduleResultsEntity({
    required this.schedule,
  });

  factory WeeklyScheduleResultsEntity.empty() {
    return const WeeklyScheduleResultsEntity(schedule: []);
  }

  @override
  List<Object?> get props => [schedule];
}
