
import '../../domain/entity/employee_schedule_rest_entity.dart';

class EmployeeScheduleRestModel extends EmployeeScheduleRestEntity {
  const EmployeeScheduleRestModel({required super.startTime, required super.endTime});
  
  factory EmployeeScheduleRestModel.fromJson(Map<String,dynamic> json) {
    return EmployeeScheduleRestModel(startTime: json['start'], endTime: json['end'],);
  }

}

