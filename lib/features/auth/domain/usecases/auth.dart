// ignore_for_file: unused_import

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/entities/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/login_request_params.dart';
import '../repositories/authentication_repository.dart';

class LogginedUser extends UseCase<void, NoParams> {
  final AuthenticationRepository _authenticationRepository;

  LogginedUser(this._authenticationRepository);

  @override
  Future<Either<AppError, bool>> call(NoParams params) =>
      _authenticationRepository.logginedUser();
}
