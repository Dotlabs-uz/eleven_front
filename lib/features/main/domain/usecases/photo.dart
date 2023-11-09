import 'package:dartz/dartz.dart';
import 'package:eleven_crm/features/main/domain/entity/order_entity.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/entities/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/current_user_entity.dart';
import '../repository/main_repository.dart';

class SaveAvatar extends UseCase<bool, SaveAvatarParams> {
  final MainRepository repository;

  SaveAvatar(this.repository);

  @override
  Future<Either<AppError, bool>> call(SaveAvatarParams params) async {
    return await repository.savePhoto(params.file, params.userId);
  }
}


class SaveAvatarParams {
  final String file;
  final String userId;

  SaveAvatarParams(this.file, this.userId);
}