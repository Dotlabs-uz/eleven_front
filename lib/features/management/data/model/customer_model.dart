
import '../../../../core/entities/field_entity.dart';
import '../../domain/entity/customer_entity.dart';

class CustomerModel extends CustomerEntity {
  const CustomerModel({
    required int id,
    required String fullName,
    required String createdAt,
    required String updatedAt,
    required String phoneNumber,
    required String address,
  }) : super(
    id: id,
    fullName: fullName,
    createdAt: createdAt,
    updatedAt: updatedAt,
    phoneNumber: phoneNumber,
    address: address,
  );


  List<MobileFieldEntity> getFieldsAndValues() {
    return [
      MobileFieldEntity(
        title: "id",
        type: Types.int,
        val: id,
      ),
      MobileFieldEntity(
        title: "fullName",
        type: Types.string,
        val: fullName,
      ),
      MobileFieldEntity(
        title: "phoneNumber",
        type: Types.string,
        val: phoneNumber,
      ),
      MobileFieldEntity(
        title: "address",
        type: Types.string,
        val: address,
      ),
    ];
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      fullName: json['full_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      phoneNumber: json['phone_number'],
      address: json['address'],
    );
  }

  factory CustomerModel.fromEntity(CustomerEntity entity) {
    return CustomerModel(
      id: entity.id,
      fullName: entity.fullName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['phone_number'] = phoneNumber;
    data['address'] = address;
    return data;
  }
}
