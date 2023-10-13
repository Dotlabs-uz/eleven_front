import '../../domain/entity/service_results_product_entity.dart';
import 'service_product_model.dart';

class ServiceResultsProductModel extends ServiceResultsProductEntity {
  const ServiceResultsProductModel({
    required super.count,
    required super.pageCount,
    required super.results,
  });

  factory ServiceResultsProductModel.fromJson(Map<String, dynamic> json) {
    return ServiceResultsProductModel(
      count: json['count'],
      pageCount: json['pageCount'],
      results: List.from(json['results'])
          .map((e) => ServiceProductModel.fromJson(e))
          .toList(),
    );
  }
}
