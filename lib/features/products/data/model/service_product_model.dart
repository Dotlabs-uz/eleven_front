import '../../domain/entity/service_product_entity.dart';

class ServiceProductModel extends ServiceProductEntity {
  const ServiceProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.duration,
    required super.categoryId,
    required super.sex,
  });

  factory ServiceProductModel.fromJson(Map<String, dynamic> json) {
    return ServiceProductModel(
      id: json['__id'],
      name: json['name'],
      price: json['price'],
      duration: json['duration'],
      categoryId: json['category_id'],
      sex: json['sex'],
    );
  }

  factory ServiceProductModel.fromEntity(ServiceProductEntity entity) {
    return ServiceProductModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      duration: entity.duration,
      categoryId: entity.categoryId,
      sex: entity.sex,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['duration'] = duration;
    data['category_id'] = categoryId;
    data['sex'] = sex;

    return data;
  }
}
