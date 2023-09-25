import '../../domain/entity/employee_schedule_results_entity.dart';
import 'employee_schedule_model.dart';

class EmployeeScheduleResultsModel extends EmployeeScheduleResultsEntity {

  const EmployeeScheduleResultsModel({required super.results});

  factory EmployeeScheduleResultsModel.fromJson(Map<String, dynamic> json) {
    return EmployeeScheduleResultsModel(
      results: List.from(json['results'])
          .map((e) => EmployeeScheduleModel.fromJson(json))
          .toList(),
    );
  }
}
