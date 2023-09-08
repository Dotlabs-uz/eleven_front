import 'package:dartz/dartz.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/entities/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repository.dart';

class DeleteUser extends UseCase<void, DeleteUserParams> {
  final AuthenticationRepository _authenticationRepository;

  DeleteUser(this._authenticationRepository);

  @override
  Future<Either<AppError, void>> call(DeleteUserParams params) async =>
      _authenticationRepository.deleteUser(smsCode: params.smsCode);
}

class DeleteUserParams {
  final String smsCode;

  DeleteUserParams(this.smsCode);
}

