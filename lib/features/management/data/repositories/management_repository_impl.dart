import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_entity.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_results_entity.dart';
import 'package:eleven_crm/features/management/domain/entity/employee_results_entity.dart';

import '../../../../core/api/api_exceptions.dart';
import '../../../../core/entities/app_error.dart';
import '../../domain/entity/customer_entity.dart';
import '../../domain/entity/customer_results_entity.dart';
import '../../domain/entity/employee_entity.dart';
import '../../domain/repositories/management_repository.dart';
import '../datasources/management_remote_data_source.dart';
import '../model/barber_model.dart';
import '../model/customer_model.dart';
import '../model/employee_model.dart';

class ManagementRepositoryImpl extends ManagementRepository {
  final ManagementRemoteDataSource remoteDataSource;

  ManagementRepositoryImpl(this.remoteDataSource);

//===Customer CRUD=======
  @override
  Future<Either<AppError, CustomerResultsEntity>> getCustomer(
    int page,
    String searchText,
    String? ordering,
    String? startDate,
    String? endDate,
  ) async {
    try {
      final entity = await remoteDataSource.getCustomer(
        page,
        searchText,
        ordering,
        startDate,
        endDate,
      );

      return Right(entity);
    } on SocketException {
      return const Left(AppError(appErrorType: AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(appErrorType: AppErrorType.unauthorised));
    } on ExceptionWithMessage catch (e) {
      return Left(
        AppError(appErrorType: AppErrorType.msgError, errorMessage: e.message),
      );
    }
  }

  @override
  Future<Either<AppError, CustomerEntity>> saveCustomer(
      CustomerEntity data,) async {
    try {
      final model = CustomerModel.fromEntity(data);

      final results = await remoteDataSource.saveCustomer(model);

      return Right(results);
    } on SocketException {
      return const Left(AppError(appErrorType: AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(appErrorType: AppErrorType.unauthorised));
    } on ExceptionWithMessage catch (e) {
      return Left(AppError(
          appErrorType: AppErrorType.msgError, errorMessage: e.message));
    }
  }

  @override
  Future<Either<AppError, bool>> deleteCustomer(CustomerEntity entity) async {
    try {
      final model = CustomerModel.fromEntity(entity);

      final result = await remoteDataSource.deleteCustomer(model.id);

      return Right(result);
    } on SocketException {
      return const Left(AppError(appErrorType: AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(appErrorType: AppErrorType.unauthorised));
    } on ExceptionWithMessage catch (e) {
      return Left(AppError(
          appErrorType: AppErrorType.msgError, errorMessage: e.message));
    }
  }

  //===Employee CRUD=======
  @override
  Future<Either<AppError, EmployeeResultsEntity>> getEmployee(
      int page,
      String searchText,
      ) async {
    try {
      final entity = await remoteDataSource.getEmployee(
        page,
        searchText,
      );

      return Right(entity);
    } on SocketException {
      return const Left(AppError(appErrorType: AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(appErrorType: AppErrorType.unauthorised));
    } on ExceptionWithMessage catch (e) {
      return Left(
        AppError(appErrorType: AppErrorType.msgError, errorMessage: e.message),
      );
    }
  }

  @override
  Future<Either<AppError, EmployeeEntity>> saveEmployee(
      EmployeeEntity data,) async {
    try {
      final model = EmployeeModel.fromEntity(data);

      final results = await remoteDataSource.saveEmployee(model);

      return Right(results);
    } on SocketException {
      return const Left(AppError(appErrorType: AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(appErrorType: AppErrorType.unauthorised));
    } on ExceptionWithMessage catch (e) {
      return Left(AppError(
          appErrorType: AppErrorType.msgError, errorMessage: e.message));
    }
  }

  @override
  Future<Either<AppError, bool>> deleteEmployee(EmployeeEntity entity) async {
    try {
      final model = EmployeeModel.fromEntity(entity);

      final result = await remoteDataSource.deleteEmployee(model.id);

      return Right(result);
    } on SocketException {
      return const Left(AppError(appErrorType: AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(appErrorType: AppErrorType.unauthorised));
    } on ExceptionWithMessage catch (e) {
      return Left(AppError(
          appErrorType: AppErrorType.msgError, errorMessage: e.message));
    }
  }

  // ================ BARBER CRUD ================ //



  @override
  Future<Either<AppError, bool>> deleteBarber(BarberEntity entity) async  {
    try {
      final model = BarberModel.fromEntity(entity);

      final result = await remoteDataSource.deleteBarber(model.id);

      return Right(result);
    } on SocketException {
      return const Left(AppError(appErrorType: AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(appErrorType: AppErrorType.unauthorised));
    } on ExceptionWithMessage catch (e) {
      return Left(AppError(
          appErrorType: AppErrorType.msgError, errorMessage: e.message));
    }
  }

  @override
  Future<Either<AppError, BarberResultsEntity>> getBarber(int page, String searchText, String? ordering) async {
    try {

      final result = await remoteDataSource.getBarber(page, searchText, ordering);

      return Right(result);
    } on SocketException {
      return const Left(AppError(appErrorType: AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(appErrorType: AppErrorType.unauthorised));
    } on ExceptionWithMessage catch (e) {
      return Left(AppError(
          appErrorType: AppErrorType.msgError, errorMessage: e.message));
    }
  }

  @override
  Future<Either<AppError, BarberEntity>> saveBarber(BarberEntity data)async  {
    try {
      final model = BarberModel.fromEntity(data);

      final result = await remoteDataSource.saveBarber(model);

      return Right(result);
    } on SocketException {
      return const Left(AppError(appErrorType: AppErrorType.network));
    } on UnauthorisedException {
      return const Left(AppError(appErrorType: AppErrorType.unauthorised));
    } on ExceptionWithMessage catch (e) {
      return Left(AppError(
          appErrorType: AppErrorType.msgError, errorMessage: e.message));
    }
  }
}
