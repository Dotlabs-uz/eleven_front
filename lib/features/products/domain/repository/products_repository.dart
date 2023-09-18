import 'package:dartz/dartz.dart';

import '../../../../core/entities/app_error.dart';
import '../entity/service_product_entity.dart';
import '../entity/service_results_product_entity.dart';

abstract class  ProductsRepository {

  // ================ Customer ================ //

  Future<Either<AppError, ServiceResultsProductEntity>> getServiceProducts(
      int page,
      String searchText,
      String? ordering,
      );
  Future<Either<AppError, ServiceProductEntity>> saveServiceProduct(ServiceProductEntity data);
  Future<Either<AppError, bool>> deleteServiceProduct(ServiceProductEntity entity);
}