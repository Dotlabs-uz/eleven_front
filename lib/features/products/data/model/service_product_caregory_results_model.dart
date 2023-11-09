import '../../domain/entity/service_product_category_results_entity.dart';
import 'service_product_category_model.dart';

class ServiceProductCategoryResultsModel
    extends ServiceProductCategoryResultsEntity {
  const ServiceProductCategoryResultsModel({
    required super.count,
    required super.pageCount,
    required super.results,
  });

  factory ServiceProductCategoryResultsModel.fromJson(
      Map<String, dynamic> json) {
    return ServiceProductCategoryResultsModel(
      count: json['count'],
      pageCount: json['pageCount'],
      results: List.from(json['results'])
          .map((e) => ServiceProductCategoryModel.fromJson(Map.from(e), false))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};

    dataMap['count'] = count;
    dataMap['pageCount'] = pageCount;
    dataMap['results'] = List.from(results).map((e) => e.toJson()).toList();
    return dataMap;
  }
}
