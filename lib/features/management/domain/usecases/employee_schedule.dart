import 'package:dartz/dartz.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../../presentation/widgets/employee_schedule_widget.dart';
import '../repositories/management_repository.dart';

class SaveEmployeeSchedule extends UseCase<bool, List<FieldSchedule>>{
  final ManagementRepository repository;

  SaveEmployeeSchedule(this.repository);

  @override
  Future<Either<AppError, bool>> call(List<FieldSchedule> params) async {
    return await repository.saveEmployeeScheduleList(params);
  }
}

