import 'package:dartz/dartz.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/entities/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/current_user_entity.dart';
import '../repository/main_repository.dart';

class SaveNotWorkingHours
    extends UseCase<bool, SaveNotWorkingHoursParams> {
  final MainRepository repository;

  SaveNotWorkingHours(this.repository);

  @override
  Future<Either<AppError, bool>> call(
      SaveNotWorkingHoursParams params) async {
    return await repository.saveNotWorkingHours(
      params.from,
      params.to,
      params.employeeId,
    );
  }
}

class SaveNotWorkingHoursParams {
  final DateTime from;
  final DateTime to;
  final String employeeId;

  const SaveNotWorkingHoursParams(
      {required this.from, required this.to, required this.employeeId});
}
