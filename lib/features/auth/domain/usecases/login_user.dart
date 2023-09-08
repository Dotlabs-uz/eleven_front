// ignore_for_file: unused_import

import 'package:dartz/dartz.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/request_password_model.dart';
import '../../data/models/request_token_model.dart';
import '../entities/login_response_entity.dart';
import '../entities/login_request_params.dart';
import '../repositories/authentication_repository.dart';

class LoginUser extends UseCase<bool, RequestTokenModel> {
  final AuthenticationRepository _authenticationRepository;

  LoginUser(this._authenticationRepository);

  @override
  Future<Either<AppError, bool>> call(RequestTokenModel params) async =>
      _authenticationRepository.loginUser(params);
}

