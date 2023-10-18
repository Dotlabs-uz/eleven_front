// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/order_entity.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    required super.clientId,
    required super.discount,
    required super.discountPercent,
    required super.paymentType,
    required super.orderStart,
    required super.orderEnd,
    required super.price,
    required super.barberId,
    required super.services,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      orderStart: json['from'],
      orderEnd: json['to'],
      price: json['price'],
      barberId: json['barber'],
      paymentType: json['paymentType'],
      discountPercent: json['discountPer'],
      discount: json['discount'],
      clientId: json['clientId'],
      services: json['services'],
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      orderStart: entity.orderStart,
      orderEnd: entity.orderEnd,
      price: entity.price,
      barberId: entity.barberId,
      paymentType: entity.paymentType,
      discountPercent: entity.discountPercent,
      discount: entity.discount,
      clientId: entity.clientId,
      services: entity.services,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // data['_id'] = id;
    data['orderStart'] = orderStart;
    data['orderEnd'] = orderEnd;
    data['price'] = price;
    data['barberId'] = barberId;
    data['paymentType'] = paymentType;
    data['discountPercent'] = discountPercent;
    data['discount'] = discount;
    data['clientId'] = clientId;
    data['services'] = services.map((e) => e.id).toList();
    return data;
  }
}
