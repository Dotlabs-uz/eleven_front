

import '../../domain/entity/service_product_category_entity.dart';

class ServiceProductCategoryModel extends ServiceProductCategoryEntity {
  const ServiceProductCategoryModel({
    required super.id,
    required super.name,
  });

  factory ServiceProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceProductCategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }

  factory ServiceProductCategoryModel.fromEntity(ServiceProductCategoryEntity entity) {
    return ServiceProductCategoryModel(
      id: entity.id,
      name: entity.name,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['name'] = name;

    return data;
  }
}
