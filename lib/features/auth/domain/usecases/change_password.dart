import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repository.dart';

class ChangePassword extends UseCase<bool, ChangePasswordParams> {
  final AuthenticationRepository repository;
  ChangePassword(this.repository);
  @override
  Future<Either<AppError, bool>> call(ChangePasswordParams params) async {
    return await repository.changePassword(  newPassword: params.newPassword);
  }
}

class ChangePasswordParams extends Equatable {
  final String newPassword;

  const ChangePasswordParams({
    required this.newPassword,
  });

  @override
  List<Object> get props => [ newPassword];
}
