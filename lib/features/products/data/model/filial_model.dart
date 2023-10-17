import '../../domain/entity/filial_entity.dart';

class FilialModel extends FilialEntity {
  const FilialModel({required super.id, required super.name, required super.phone, required super.address});

  factory FilialModel.fromJson(Map<String, dynamic> json) {
    return FilialModel(
      id: json['_id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
    );
  }

  factory FilialModel.fromEntity(
      FilialEntity entity) {
    return FilialModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      phone: entity.phone,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['phone'] = phone;

    return data;
  }



}
