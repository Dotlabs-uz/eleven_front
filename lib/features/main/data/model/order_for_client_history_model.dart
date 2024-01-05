// ignore_for_file: must_be_immutable


import '../../../products/data/model/service_product_model.dart';
import '../../domain/entity/order_for_client_history_entity.dart';

class OrderForClientModel extends OrderForClientEntity {
  const OrderForClientModel({
    required super.barberName,
    required super.barberPhone,
    required super.createdAt,
    required super.fromSite,
    required super.services,
    required super.price,
    required super.duration,
  });

  factory OrderForClientModel.fromJson(Map<String, dynamic> json) {
    return OrderForClientModel(
      fromSite: json['fromSite'] ?? false,
      services: List.from(json['services'])
          .map((e) => ServiceProductModel.fromJson(e, false))
          .toList(),
      price: json['price'] ?? 0,
      duration: json['duration'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      barberName: json['barberName'],
      barberPhone: json['barberPhone'],
    );
  }
}
