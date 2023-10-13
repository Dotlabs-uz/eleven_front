
import '../../domain/entity/service_product_category_results_entity.dart';
import 'service_product_category_model.dart';

class ServiceProductCategoryResultsModel extends ServiceProductCategoryResultsEntity {
  const ServiceProductCategoryResultsModel({
    required super.count,
    required super.pageCount,
    required super.results,
  });

  factory ServiceProductCategoryResultsModel.fromJson(Map<String, dynamic> json) {
    return ServiceProductCategoryResultsModel(
      count: json['count'],
      pageCount: json['pageCount'],
      results: List.from(json['results'])
          .map((e) => ServiceProductCategoryModel.fromJson(e))
          .toList(),
    );
  }
}
