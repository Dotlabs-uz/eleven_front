import '../../domain/entity/service_product_category_entity.dart';
import 'service_product_model.dart';

class ServiceProductCategoryModel extends ServiceProductCategoryEntity {
  const ServiceProductCategoryModel({
    required super.id,
    required super.name,
    required super.services,
  });

  factory ServiceProductCategoryModel.fromJson(Map<String, dynamic> json, bool withCategoryParse) {
    return ServiceProductCategoryModel(
      id: json['_id'],
      name: json['name'],
      services: json['services'] != null
          ? List.of(json['services'])
              .map((e) => ServiceProductModel.fromJson(e ,withCategoryParse))
              .toList()
          : [],
    );
  }

  factory ServiceProductCategoryModel.fromEntity(
      ServiceProductCategoryEntity entity) {
    return ServiceProductCategoryModel(
      id: entity.id,
      name: entity.name,
      services: entity.services,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['_id'] = id;
    data['name'] = name;
    data['services'] = services.map((e) => ServiceProductModel.fromEntity(e).toJson())
        .toList();

    return data;
  }
}
