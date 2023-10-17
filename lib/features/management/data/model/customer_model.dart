import '../../../../core/entities/field_entity.dart';
import '../../domain/entity/customer_entity.dart';

class CustomerModel extends CustomerEntity {
  const CustomerModel({
    required String id,
    required String fullName,
    required int phoneNumber,
    required int ordersCount,
  }) : super(
          id: id,
          fullName: fullName,
          phoneNumber: phoneNumber,
          ordersCount: ordersCount,
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
        type: Types.int,
        val: phoneNumber,
      ),
      MobileFieldEntity(
        title: "ordersCount",
        type: Types.int,
        val: ordersCount,
      ),
    ];
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['_id'],
      fullName: json['name'],
      phoneNumber: json['phone'],
      ordersCount: json['ordersCount'] ?? 0,
    );
  }

  factory CustomerModel.fromEntity(CustomerEntity entity) {
    return CustomerModel(
      id: entity.id,
      fullName: entity.fullName,
      phoneNumber: entity.phoneNumber,
      ordersCount: entity.ordersCount,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = fullName;
    data['phone'] = phoneNumber;
    return data;
  }
}
