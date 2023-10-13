

import '../../domain/entity/employee_entity.dart';
import '../../domain/entity/employee_results_entity.dart';
import 'employee_model.dart';

class EmployeeResultsModel extends EmployeeResultsEntity {
  const EmployeeResultsModel({
    required int count,
    required int pageCount,
    required List<EmployeeEntity> results,
  }) : super(count: count, pageCount: pageCount, results: results,);

  factory EmployeeResultsModel.fromJson(Map<String, dynamic> json) {
    return EmployeeResultsModel(
      count: json['count'],
      pageCount: json['pageCount'],
      results: List.from(json['results'])
          .map((e) => EmployeeModel.fromJson(e))
          .toList(),
    );
  }

  Map<String,dynamic>toJson() {
    final Map<String,dynamic> data= {};
    data['count'] = count;
    data['pageCount'] = pageCount;
    data['results'] = results.map((e) =>EmployeeModel.fromEntity( e).toJson());
    return data;
  }
}
