import 'package:equatable/equatable.dart';
import 'employee_schedule_entity.dart';

class EmployeeScheduleResultsEntity extends Equatable {
  final List<EmployeeScheduleEntity> results;

  const EmployeeScheduleResultsEntity({
    required this.results,
  });

  factory EmployeeScheduleResultsEntity.empty() {
    return const EmployeeScheduleResultsEntity(
      results: [],
    );
  }

  @override
  List<Object?> get props => [results];
}
