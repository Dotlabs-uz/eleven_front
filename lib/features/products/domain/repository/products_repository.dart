import 'package:dartz/dartz.dart';
import 'package:eleven_crm/features/products/domain/entity/filial_results_entity.dart';

import '../../../../core/entities/app_error.dart';
import '../entity/service_product_category_entity.dart';
import '../entity/service_product_category_results_entity.dart';
import '../entity/service_product_entity.dart';
import '../entity/service_results_product_entity.dart';

abstract class ProductsRepository {
  // ================ Service Products  ================ //

  Future<Either<AppError, ServiceResultsProductEntity>> getServiceProducts(
    int page,
    String searchText,
    String? ordering,
    bool withCategoryParse,
  );
  Future<Either<AppError, ServiceProductEntity>> saveServiceProduct(
      ServiceProductEntity data);
  Future<Either<AppError, bool>> deleteServiceProduct(
      ServiceProductEntity entity);

  // ================ Service Products Category ================ //

  Future<Either<AppError, ServiceProductCategoryResultsEntity>>
      getServiceProductCategory(
    int page,
    String searchText,
    String? ordering,
    bool withServiceCategoryParsing,
  );

  Future<Either<AppError, ServiceProductCategoryEntity>>
      saveServiceProductCategory(ServiceProductCategoryEntity data);
  Future<Either<AppError, bool>> deleteServiceProductCategory(
      ServiceProductCategoryEntity entity);

  // ================ Filial ================ //

  Future<Either<AppError, FilialResultsEntity>> getFilials(
    int page,
    String searchText,
    String? ordering,
  );
}
