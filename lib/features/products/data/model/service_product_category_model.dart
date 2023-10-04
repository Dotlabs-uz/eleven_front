

import '../../domain/entity/service_product_category_entity.dart';
import 'service_product_model.dart';

class ServiceProductCategoryModel extends ServiceProductCategoryEntity {
  const ServiceProductCategoryModel({
    required super.id,
    required super.name,
    required super.services,
  });

  factory ServiceProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceProductCategoryModel(
      id: json['__id'],
      name: json['name'],
      services: List.of(json['services']).map((e) => ServiceProductModel.fromJson(e)).toList(),
    );
  }

  factory ServiceProductCategoryModel.fromEntity(ServiceProductCategoryEntity entity) {
    return ServiceProductCategoryModel(
      id: entity.id,
      name: entity.name,
      services: entity.services,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['name'] = name;
    data['services'] = services;

    return data;
  }
}
