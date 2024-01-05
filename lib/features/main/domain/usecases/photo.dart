import 'package:dartz/dartz.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/main_repository.dart';

class SaveAvatar extends UseCase<bool, SaveAvatarParams> {
  final MainRepository repository;

  SaveAvatar(this.repository);

  @override
  Future<Either<AppError, bool>> call(SaveAvatarParams params) async {
    return await repository.savePhoto(params.file, params.userId, params.role);
  }
}


class SaveAvatarParams {
  final List<int> file;
  final String userId;
  final String role;

  SaveAvatarParams(this.file, this.userId, this.role);
}