import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:eleven_crm/features/management/data/datasources/management_local_data_source.dart';
import 'package:eleven_crm/features/management/data/model/weekly_schedule_results_model.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_entity.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_results_entity.dart';
import 'package:eleven_crm/features/management/domain/entity/employee_results_entity.dart';
import 'package:eleven_crm/features/management/domain/entity/employee_schedule_entity.dart';
import 'package:eleven_crm/features/management/domain/entity/manager_entity.dart';
import 'package:eleven_crm/features/management/domain/entity/manager_results_entity.dart';

import '../../../../core/api/api_exceptions.dart';
import '../../../../core/entities/app_error.dart';
import '../../domain/entity/weekly_schedule_results_entity.dart';
import '../../domain/entity/customer_entity.dart';
import '../../domain/entity/customer_results_entity.dart';
import '../../domain/entity/employee_entity.dart';
import '../../domain/repositories/management_repository.dart';
import '../../presentation/widgets/employee_schedule_widget.dart';
import '../datasources/management_remote_data_source.dart';
import '../model/barber_model.dart';
import '../model/customer_model.dart';
import '../model/employee_model.dart';
import '../model/manager_model.dart';

class ManagementRepositoryImpl extends ManagementRepository {
  final ManagementRemoteDataSource remoteDataSource;
  final ManagementLocalDataSource localDataSource;

  ManagementRepositoryImpl(this.remoteDataSource, this.localDataSource);

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
      // final localData = await localDataSource.getCustomerResult(searchText);
      //
      //
      // print("Local data clients");
      //
      // if (localData != null) {
      //   return Right(localData);
      // }

      final entity = await remoteDataSource.getCustomer(
        page,
        searchText,
        ordering,
        startDate,
        endDate,
      );
      // print("save clients to local data sourse ${entity.results.first.fullName}");

      await localDataSource.saveCustomerResult(entity);

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
  Future<Either<AppError, CustomerEntity>> getCustomerById(
      String id,
      ) async {
    try {

      final entity = await remoteDataSource.getCustomerById(
        id,
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
    CustomerEntity data,
  ) async {
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
  Future<Either<AppError, EmployeeEntity>> getEmployeeEntity(String employeeId)  async {
    try {
      final entity = await remoteDataSource.getEmployeeEntity(
        employeeId,
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
    EmployeeEntity data,
  ) async {
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
  Future<Either<AppError, bool>> deleteBarber(BarberEntity entity) async {
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
  Future<Either<AppError, BarberResultsEntity>> getBarber(
      int page,int limit, String searchText, String? ordering) async {
    try {
      final result =
          await remoteDataSource.getBarber(page,limit ,searchText, ordering);

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
  Future<Either<AppError, BarberEntity>> saveBarber(BarberEntity data) async {
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

  @override
  Future<Either<AppError, bool>> saveEmployeeScheduleList(
      List<FieldSchedule> data) async {
    try {
      final result = await remoteDataSource.saveEmployeeSchedule(data);

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

  // ================ MANAGER CRUD ================ //

  @override
  Future<Either<AppError, bool>> deleteManager(ManagerEntity entity) async {
    try {
      final model = ManagerModel.fromEntity(entity);

      final result = await remoteDataSource.deleteManager(model.id);

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
  Future<Either<AppError, ManagerResultsEntity>> getManager(
    int page,
    String searchText,
  ) async {
    try {
      final result = await remoteDataSource.getManager(page, searchText);

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
  Future<Either<AppError, ManagerEntity>> saveManager(
      ManagerEntity data) async {
    try {
      final model = ManagerModel.fromEntity(data);

      final result = await remoteDataSource.saveManager(model);

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
  Future<Either<AppError, bool>> saveEmployeeWeeklySchedule(
      WeeklyScheduleResultsEntity weeklySchedule, String employeeId) async {
    try {
      final model = WeeklyScheduleResultsModel.fromEntity(weeklySchedule);

      final result =
          await remoteDataSource.saveEmployeeWeeklySchedule(model, employeeId);

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
