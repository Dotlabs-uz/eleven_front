import 'package:dartz/dartz.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/entities/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/current_user_entity.dart';
import '../repository/main_repository.dart';

class GetCurrentUser extends UseCase<CurrentUserEntity, NoParams> {
  final MainRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<AppError, CurrentUserEntity>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}

class SaveCurrentUser extends UseCase<bool, CurrentUserEntity> {
  final MainRepository repository;

  SaveCurrentUser(this.repository);

  @override
  Future<Either<AppError, bool>> call(CurrentUserEntity params) async {
    return await repository.saveCurrentUser(params);
  }
}
