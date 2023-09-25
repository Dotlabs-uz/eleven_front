
import '../../domain/entity/employee_schedule_entity.dart';
import 'employee_model.dart';

class EmployeeScheduleModel extends EmployeeScheduleEntity {
  const EmployeeScheduleModel({required super.employee, required super.status});

  factory EmployeeScheduleModel.fromJson(Map<String,dynamic> json) {
    return  EmployeeScheduleModel(
      employee: EmployeeModel.fromJson(json['employee']),
      status:[],
      // status: json['status'],
    );
  }

}
