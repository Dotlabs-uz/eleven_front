import 'package:dartz/dartz.dart';


import '../../../../core/entities/app_error.dart';
import '../entity/current_user_entity.dart';


abstract class MainRepository {
  Future<Either<AppError, CurrentUserEntity>> getCurrentUser();
  Future<Either<AppError, bool>> saveNotWorkingHours(DateTime from, DateTime to, String employeeId);

}
