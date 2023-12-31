import '../../domain/entity/service_product_category_entity.dart';
import '../../domain/entity/service_product_entity.dart';
import 'service_product_category_model.dart';

class ServiceProductModel extends ServiceProductEntity {
  const ServiceProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.duration,
    required super.category,
    required super.listBarberId,
    required super.sex,
  });

  factory ServiceProductModel.fromJson(Map<String, dynamic> json, bool withCategoryParse) {
    return ServiceProductModel(
      id: json['_id'] ?? '',
      name: json['name'],
      price: json['price'],
      duration: json['duration'],
      listBarberId: List.from(json['listBarberId']),
      category:withCategoryParse ? ServiceProductCategoryModel.fromJson(  Map<String ,dynamic>.from(json['category'] ),false) : ServiceProductCategoryModel.fromEntity(ServiceProductCategoryEntity.empty()),
      sex: json['sex'] ?? "men",
    );
  }

  factory ServiceProductModel.fromEntity(ServiceProductEntity entity) {
    return ServiceProductModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      duration: entity.duration,
      category: entity.category,
      listBarberId: entity.listBarberId,
      sex: entity.sex,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['duration'] = duration;
    data['listBarberId'] = listBarberId;
    data['category'] =
        category.id;
    data['sex'] = sex;

    return data;
  }
}

