
import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:eleven_crm/core/entities/app_error.dart';
import 'package:eleven_crm/features/products/data/datasources/products_remote_data_source.dart';
import 'package:eleven_crm/features/products/domain/entity/service_product_category_entity.dart';
import 'package:eleven_crm/features/products/domain/entity/service_product_category_results_entity.dart';


import '../../../../core/api/api_exceptions.dart';
import '../../domain/entity/service_product_entity.dart';
import '../../domain/entity/service_results_product_entity.dart';
import '../../domain/repository/products_repository.dart';
import '../model/service_product_category_model.dart';
import '../model/service_product_model.dart';

class ProductsRepositoryImpl extends ProductsRepository  {

  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<AppError, bool>> deleteServiceProduct(ServiceProductEntity entity)async  {
    try {

      final model = ServiceProductModel.fromEntity(entity);

      final result = await remoteDataSource.deleteServiceProduct(model.id);

      return Right(result);

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
  Future<Either<AppError, ServiceResultsProductEntity>> getServiceProducts(int page, String searchText, String? ordering,)async  {
    try {

      final entity = await remoteDataSource.getServiceProducts(
        page,
        searchText,
        ordering,
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
  Future<Either<AppError, ServiceProductEntity>> saveServiceProduct(ServiceProductEntity data) async {
    try {

      final model = ServiceProductModel.fromEntity(data);

      final results = await remoteDataSource.saveServiceProduct(model);

      return Right(results);
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
  Future<Either<AppError, bool>> deleteServiceProductCategory(ServiceProductCategoryEntity  entity) async {
    try {

      final results = await remoteDataSource.deleteServiceProductCategory(entity.id);

      return Right(results);
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
  Future<Either<AppError, ServiceProductCategoryResultsEntity>> getServiceProductCategory(int page, String searchText, String? ordering) async {
    try {

      final results = await remoteDataSource.getServiceProductCategory(page,searchText,ordering);

      return Right(results);
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
  Future<Either<AppError, ServiceProductCategoryEntity>> saveServiceProductCategory(ServiceProductCategoryEntity data) async {
    try {

      final model = ServiceProductCategoryModel.fromEntity(data);

      final results = await remoteDataSource.saveServiceProductCategory(model);

      return Right(results);
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
}