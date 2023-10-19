import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/service_product_entity.dart';
import '../entity/service_results_product_entity.dart';
import '../repository/products_repository.dart';

class GetServiceProduct extends UseCase<ServiceResultsProductEntity, GetServiceProductParams> {
  final ProductsRepository repository;

  GetServiceProduct(this.repository);

  @override
  Future<Either<AppError, ServiceResultsProductEntity>> call(
      GetServiceProductParams params) async {
    return await repository.getServiceProducts(
      params.page,
      params.searchText,
      params.ordering,
      params.withCategoryParse,
    );
  }
}

class SaveServiceProduct extends UseCase<ServiceProductEntity, ServiceProductEntity> {
  final ProductsRepository repository;

  SaveServiceProduct(this.repository);

  @override
  Future<Either<AppError, ServiceProductEntity>> call(ServiceProductEntity params) async {
    return await repository.saveServiceProduct(params);
  }
}

class DeleteServiceProduct extends UseCase<void, ServiceProductEntity> {
  final ProductsRepository repository;

  DeleteServiceProduct(this.repository);

  @override
  Future<Either<AppError, void>> call(ServiceProductEntity params) async {
    return await repository.deleteServiceProduct(params);
  }
}


class GetServiceProductParams extends Equatable {
  final int page;
  final String searchText;
  final String? ordering;
  final bool withCategoryParse;

  const GetServiceProductParams({
    required this.page,
    this.ordering,
    this.withCategoryParse = true,
    this.searchText = '',
  });

  @override
  List<Object?> get props => [page];
}
