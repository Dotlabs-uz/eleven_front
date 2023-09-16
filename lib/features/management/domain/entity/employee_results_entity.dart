import 'package:equatable/equatable.dart';

import 'employee_entity.dart';

class EmployeeResultsEntity  extends Equatable{
  final int count;
  final int pageCount;
  final List<EmployeeEntity> results;

  const EmployeeResultsEntity({
    required this.count,
    required this.pageCount,
    required this.results,
  });

  @override
  List<Object?> get props => [
    count,
    pageCount,
    results,
  ];
}
