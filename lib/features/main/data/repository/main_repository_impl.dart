// ignore_for_file: unused_import, unused_field

import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:eleven_crm/features/main/domain/entity/current_user_entity.dart';

import '../../../../core/api/api_exceptions.dart';
import '../../../../core/entities/app_error.dart';
import '../../domain/repository/main_repository.dart';
import '../datasources/main_remote_data_source.dart';


class MainRepositoryImpl extends MainRepository {
  final MainRemoteDataSource _mainRemoteDataSource;

  MainRepositoryImpl(
    this._mainRemoteDataSource,
  );

  @override
  Future<Either<AppError, CurrentUserEntity>> getCurrentUser() async {
    try {

        final entity = await _mainRemoteDataSource.getCurrentUser();


      return Right(entity);
    } on SocketException {
      return const Left(AppError(appErrorType: AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(appErrorType: AppErrorType.unauthorised));
    } on ExceptionWithMessage catch (e) {
      return Left(AppError(
          appErrorType: AppErrorType.msgError, errorMessage: e.message));
    } on Exception {
      return const Left(AppError(appErrorType: AppErrorType.api));
    }
  }
}
