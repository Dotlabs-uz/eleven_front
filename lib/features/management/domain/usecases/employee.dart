import 'package:dartz/dartz.dart';
import 'package:eleven_crm/features/management/domain/entity/weekly_schedule_results_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/employee_entity.dart';
import '../entity/employee_results_entity.dart';
import '../repositories/management_repository.dart';

class GetEmployee extends UseCase<EmployeeResultsEntity, GetEmployeeParams> {
  final ManagementRepository repository;

  GetEmployee(this.repository);

  @override
  Future<Either<AppError, EmployeeResultsEntity>> call(
      GetEmployeeParams params,) async {
    return await repository.getEmployee(
      params.page,
      params.searchText,
    );
  }
}


class GetEmployeeEntity extends UseCase<EmployeeEntity, String> {
  final ManagementRepository repository;

  GetEmployeeEntity(this.repository);

  @override
  Future<Either<AppError, EmployeeEntity>> call(
      String params,) async {
    return await repository.getEmployeeEntity(
      params,
    );
  }
}

class SaveEmployee extends UseCase<EmployeeEntity, EmployeeEntity>{
  final ManagementRepository repository;

  SaveEmployee(this.repository);

  @override
  Future<Either<AppError, EmployeeEntity>> call(EmployeeEntity params) async {
    return await repository.saveEmployee(params);
  }
}


class SaveEmployeeWeeklySchedule extends UseCase<bool, SaveEmployeeWeeklyScheduleParams>{
  final ManagementRepository repository;

  SaveEmployeeWeeklySchedule(this.repository);

  @override
  Future<Either<AppError, bool>> call(SaveEmployeeWeeklyScheduleParams params) async {
    return await repository.saveEmployeeWeeklySchedule(params.weeklySchedule, params.employeeId);
  }
}


class DeleteEmployee extends UseCase<void, EmployeeEntity> {
  final ManagementRepository repository;

  DeleteEmployee(this.repository);

  @override
  Future<Either<AppError, void>> call(EmployeeEntity params) async {
    return await repository.deleteEmployee(params);
  }
}


class GetEmployeeParams extends Equatable {
  final int page;
  final String searchText;

  const GetEmployeeParams({
    required this.page,
    this.searchText = '',
  });

  @override
  List<Object?> get props => [page];
}
class SaveEmployeeWeeklyScheduleParams extends Equatable {
  final WeeklyScheduleResultsEntity weeklySchedule;
  final String employeeId;

  const SaveEmployeeWeeklyScheduleParams({
    required this.weeklySchedule,
    required this.employeeId,
  });

  @override
  List<Object?> get props => [employeeId];
}
