// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/order_entity.dart';

class OrderModel extends OrderEntity {
  OrderModel({
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
      orderStart: json['from'],
      orderEnd: json['to'],
      price: json['price'],
      barberId: json['barber'],
      paymentType: json['paymentType'],
      discountPercent: json['discountPer'],
      discount: json['discount'],
      clientId: json['clientId'], services: json['services'],
    );
  }


}
