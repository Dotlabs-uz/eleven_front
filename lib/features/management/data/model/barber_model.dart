// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';

import '../../../../core/entities/field_entity.dart';
import '../../../products/data/model/filial_model.dart';
import '../../domain/entity/barber_entity.dart';
import '../../domain/entity/weekly_schedule_results_entity.dart';
import 'weekly_schedule_item_model.dart';
import 'weekly_schedule_results_model.dart';
import 'not_working_hours_model.dart';

@immutable
class BarberModel extends BarberEntity {
  BarberModel({
    required super.id,
    required super.employeeId,
    required super.firstName,
    required super.lastName,
    required super.phone,
    required super.filial,
    required super.avatar,
    required super.password,
    required super.login,
    required super.isOnline,
    required super.isActive,
    required super.inTimeTable,
    required super.notWorkingHours,
    required super.isCurrentFilial,
    required super.weeklySchedule,
  });

  List<MobileFieldEntity> getFieldsAndValues() {
    return [
      MobileFieldEntity(
        title: "id",
        type: Types.int,
        val: id,
      ),
      MobileFieldEntity(
        title: "firstName",
        type: Types.string,
        val: firstName,
      ),
      MobileFieldEntity(
        title: "lastName",
        type: Types.string,
        val: lastName,
      ),
      MobileFieldEntity(
        title: "password",
        type: Types.string,
        val: password,
      ),
      MobileFieldEntity(
        title: "login",
        type: Types.string,
        val: login,
      ),
      MobileFieldEntity(
        title: "phoneNumber",
        type: Types.int,
        val: phone,
      ),
    ];
  }

  factory BarberModel.fromJson(Map<String, dynamic> json) {
    return BarberModel(
      id: json['_id'],
      firstName: json['firstName'],
      employeeId: json['employeeId'],
      lastName: json['lastName'],
      phone: json['phone'],
      isActive: json['isActive'] ?? true,
      isOnline: json['isOnline'] ?? true,
      filial: FilialModel.fromJson(json['filial']),
      login: json['login'],
      inTimeTable: json['inTimeTable'] ?? false,
      password: "",
      notWorkingHours: json['notWorkingHours'] != null &&
              List.from(json['notWorkingHours']).isNotEmpty
          ? List.from(json['notWorkingHours'])
              .map((e) => NotWorkingHoursModel.fromJson(e))
              .toList()
          : [],
      avatar: json['avatar'] ?? "",
      isCurrentFilial: json['isCurrentFilial'] ?? false,
      weeklySchedule: WeeklyScheduleResultsModel.fromJson( json['weeklySchedule']),
    );
  }

  factory BarberModel.fromEntity(BarberEntity entity) {
    return BarberModel(
      id: entity.id,
      firstName: entity.firstName,
      employeeId: entity.employeeId,
      lastName: entity.lastName,
      phone: entity.phone,
      isActive: entity.isActive,
      isOnline: entity.isOnline,
      filial: entity.filial,
      password: entity.password,
      login: entity.login,
      inTimeTable: entity.inTimeTable,
      notWorkingHours: entity.notWorkingHours,
      avatar: entity.avatar,
      isCurrentFilial: entity.isCurrentFilial,
      weeklySchedule: entity.weeklySchedule,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // data['_id'] = id;

    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phone'] = phone;
    data['filial'] = filial.id;
    data['login'] = "test";
    data['password'] = "test";
    data['inTimeTable'] = inTimeTable;
    data['isActive'] = isActive;
    data['isOnline'] = isOnline;

    // if(id.isNotEmpty) {
    //   data['weeklySchedule'] = WeeklyScheduleResultsModel.fromEntity(weeklySchedule).toJson();
    // }
    return data;
  }
}
