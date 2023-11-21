// ignore_for_file: must_be_immutable

import 'package:eleven_crm/features/management/domain/entity/barber_schedule_entity.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/barber_schedule_results_entity.dart';
import 'barber_schedule_model.dart';

@immutable
class BarberScheduleResultsModel extends BarberScheduleResultsEntity {
  const BarberScheduleResultsModel({required super.schedule});

  factory BarberScheduleResultsModel.fromJson(List<dynamic> data) {


    return BarberScheduleResultsModel(
        schedule: data.map((e) => BarberScheduleModel.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['weeklySchedule'] = schedule
        .map((e) => BarberScheduleModel.fromEntity(e).toJson())
        .toList();

    return data;
  }
}
