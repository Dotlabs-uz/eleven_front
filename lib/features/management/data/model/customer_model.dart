import 'package:eleven_crm/features/main/data/model/order_for_client_history_model.dart';

import '../../../../core/entities/field_entity.dart';
import '../../domain/entity/customer_entity.dart';

class CustomerModel extends CustomerEntity {
  const CustomerModel(
      {required super.id,
      required super.fullName,
      required super.phoneNumber,
      required super.ordersCount,
      required super.orders});

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

  factory CustomerModel.fromJson(Map<String, dynamic> json,
      {bool isForOrder = false}) {

    return CustomerModel(
      id: json['_id'] ?? "",
      fullName: json['name'] ?? "",
      phoneNumber: json['phone'] ?? 998,
      ordersCount:isForOrder ?0 : List.from(json['orders']).length,
      orders: isForOrder ? [] : List.from(json['orders'])
          .map((e) => OrderForClientModel.fromJson(e))
          .toList(),
    );
  }

  factory CustomerModel.fromEntity(CustomerEntity entity) {
    return CustomerModel(
      id: entity.id,
      fullName: entity.fullName,
      phoneNumber: entity.phoneNumber,
      ordersCount: entity.ordersCount,
      orders: entity.orders,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = fullName;
    data['phone'] = phoneNumber;
    data['ordersCount'] = ordersCount;
    return data;
  }

  Map<String, dynamic> toNewJson() {
    final data = <String, dynamic>{};
    data['name'] = fullName;
    data['phone'] = phoneNumber;
    data['ordersCount'] = ordersCount;
    return data;
  }
}
