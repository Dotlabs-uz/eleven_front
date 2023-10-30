// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../products/data/model/service_product_model.dart';
import '../../domain/entity/order_entity.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    required super.clientId,
    // required super.discount,
    // required super.discountPercent,
    required super.paymentType,
    required super.orderStart,
    required super.orderEnd,
    // required super.price,
    required super.barberId,
    required super.services,
    required super.isNew,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? "",
      orderStart: DateTime.parse(json['orderStart']),
      orderEnd: DateTime.parse(json['orderEnd'].toString().replaceAll("Z", "").replaceAll("z", "")),
      barberId: json['barber']['_id'],
      paymentType:
          json['payment'] == "cash" ? OrderPayment.card : OrderPayment.card,
      // discountPercent: json['discountPer'],
      // discount: json['discount'],
      clientId: json['client']['_id'],
      services: List.from(json['services'])
          .map((e) => ServiceProductModel.fromJson(e, false))
          .toList(),
      isNew: json['isNew'],
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      orderStart: entity.orderStart,
      orderEnd: entity.orderEnd,
      // price: entity.price,
      barberId: entity.barberId,
      paymentType: entity.paymentType,
      // discountPercent: entity.discountPercent,
      // discount: entity.discount,
      clientId: entity.clientId,
      services: entity.services,
      isNew: entity.isNew,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['orderStart'] = orderStart.toIso8601String();
    data['orderEnd'] = orderEnd.toIso8601String();
    // data['price'] = price;
    data['barber'] = barberId;
    data['payments'] = paymentType.name;
    // data['discountPercent'] = discountPercent;
    // data['discount'] = discount;
    data['client'] = clientId;
    print("Services $services");
    data['services'] = services.map((e) => e.id).toList();

    return data;
  }
}
