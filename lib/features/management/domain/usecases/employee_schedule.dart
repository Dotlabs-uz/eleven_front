import 'package:dartz/dartz.dart';
import 'package:eleven_crm/core/entities/no_params.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../../presentation/widgets/employee_schedule_widget.dart';
import '../entity/employee_entity.dart';
import '../entity/employee_results_entity.dart';
import '../entity/employee_schedule_entity.dart';
import '../repositories/management_repository.dart';

class SaveEmployeeSchedule extends UseCase<bool, List<FieldSchedule>>{
  final ManagementRepository repository;

  SaveEmployeeSchedule(this.repository);

  @override
  Future<Either<AppError, bool>> call(List<FieldSchedule> params) async {
    return await repository.saveEmployeeScheduleList(params);
  }
}

