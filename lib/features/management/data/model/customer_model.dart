import '../../../../core/entities/field_entity.dart';
import '../../domain/entity/customer_entity.dart';

class CustomerModel extends CustomerEntity {
  const CustomerModel({
    required String id,
    required String fullName,
    required String phoneNumber,
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
        type: Types.string,
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
      id: json['__id'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      ordersCount: json['orders_count'] ?? 0,
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
    data['__id'] = id;
    data['full_name'] = fullName;
    data['phone_number'] = phoneNumber;
    data['orders_count'] = ordersCount;
    return data;
  }
}
