import 'package:dartz/dartz.dart';
import 'package:eleven_crm/features/products/domain/entity/service_product_category_results_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/service_product_category_entity.dart';
import '../entity/service_product_entity.dart';
import '../entity/service_results_product_entity.dart';
import '../repository/products_repository.dart';

class GetServiceProductCategory extends UseCase<ServiceProductCategoryResultsEntity, GetServiceProductCategoryParams> {
  final ProductsRepository repository;

  GetServiceProductCategory(this.repository);

  @override
  Future<Either<AppError, ServiceProductCategoryResultsEntity>> call(GetServiceProductCategoryParams params) async {
    return await repository.getServiceProductCategory(
      params.page,
      params.searchText,
      params.ordering,
      params.withServiceCategoryParsing,
      params.fetchGlobal,
    );
  }
}

class SaveServiceProductCategory extends UseCase<ServiceProductCategoryEntity, ServiceProductCategoryEntity> {
  final ProductsRepository repository;

  SaveServiceProductCategory(this.repository);

  @override
  Future<Either<AppError, ServiceProductCategoryEntity>> call(ServiceProductCategoryEntity params) async {
    return await repository.saveServiceProductCategory(params);
  }
}

class DeleteServiceProductCategory extends UseCase<void, ServiceProductCategoryEntity> {
  final ProductsRepository repository;

  DeleteServiceProductCategory(this.repository);

  @override
  Future<Either<AppError, void>> call(ServiceProductCategoryEntity params) async {
    return await repository.deleteServiceProductCategory(params);
  }
}


class GetServiceProductCategoryParams extends Equatable {
  final int page;
  final String searchText;
  final String? ordering;
  final bool withServiceCategoryParsing;
  final bool fetchGlobal;


  const GetServiceProductCategoryParams({
    required this.page,
    this.ordering,
    this.withServiceCategoryParsing = false,
    required this.fetchGlobal ,
    this.searchText = '',
  });

  @override
  List<Object?> get props => [page];
}
