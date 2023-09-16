import 'package:dartz/dartz.dart';

import '../../../../core/entities/app_error.dart';
import '../../data/models/request_token_model.dart';

abstract class AuthenticationRepository {
  Future<Either<AppError, bool>> loginUser(RequestTokenModel model);
  Future<Either<AppError, void>> logoutUser();
  Future<Either<AppError, void>> deleteUser({required String smsCode});
  Future<Either<AppError, bool>> changePassword({
    required String newPassword,
  });
  Future<Either<AppError, bool>> logginedUser();
}
