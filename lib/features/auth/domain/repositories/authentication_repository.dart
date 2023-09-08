import 'package:dartz/dartz.dart';

import '../../../../core/entities/app_error.dart';
import '../../data/models/request_password_model.dart';
import '../../data/models/request_token_model.dart';
import '../entities/login_response_entity.dart';

abstract class AuthenticationRepository {
  Future<Either<AppError, bool>> loginUser(RequestTokenModel model);
  Future<Either<AppError, void>> logoutUser();
  Future<Either<AppError, void>> deleteUser({required String smsCode});
  Future<Either<AppError, bool>> changePassword({
    required String newPassword,
  });
  Future<Either<AppError, bool>> logginedUser();
}
