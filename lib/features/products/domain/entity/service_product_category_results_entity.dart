
import 'package:eleven_crm/features/products/domain/entity/service_product_category_entity.dart';
import 'package:equatable/equatable.dart';


class ServiceProductCategoryResultsEntity extends Equatable {
  final int count;
  final int pageCount;
  final List<ServiceProductCategoryEntity> results;

  const ServiceProductCategoryResultsEntity({
    required this.count,
    required this.pageCount,
    required this.results,
  });

  @override
  List<Object?> get props => [count, pageCount, results,];


}
