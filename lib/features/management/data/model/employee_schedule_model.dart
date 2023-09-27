
import '../../domain/entity/employee_schedule_entity.dart';

class EmployeeScheduleModel extends EmployeeScheduleEntity {
  const EmployeeScheduleModel({
    required super.startTime,
    required super.endTime,
    required super.status,
    // required super.rest,
  });

  factory EmployeeScheduleModel.fromJson(Map<String, dynamic> json) {
    return EmployeeScheduleModel(
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
      // rest: List.from(json['rest'])
      //     .map((e) => EmployeeScheduleRestModel.fromJson(e))
      //     .toList(),
    );
  }

  factory EmployeeScheduleModel.fromEntity(EmployeeScheduleEntity entity) {
    return EmployeeScheduleModel(
      startTime: entity.startTime,
      endTime: entity.endTime,
      status: entity.status,
      // rest: entity.rest,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['status'] = status;
    // data['rest'] = rest;
    return data;
  }
}
