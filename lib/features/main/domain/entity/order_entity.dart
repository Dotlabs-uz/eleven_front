// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../products/domain/entity/service_product_entity.dart';


enum OrderPayment {
  cash,
  card,

}
@immutable
class OrderEntity extends Equatable {
  final double discount;
  final double discountPercent;
  final OrderPayment paymentType;
  final int price;
  DateTime orderStart;
  DateTime orderEnd;
  String barberId;
  final String clientId;
  final List<ServiceProductEntity> services;

  OrderEntity({
    required this.discount,
    required this.discountPercent,
    required this.paymentType,
    required this.orderStart,
    required this.orderEnd,
    required this.price,
    required this.barberId,
    required this.clientId,
    required this.services,
  });

  @override
  List<Object?> get props => [
        discount,
        discountPercent,
        paymentType,
        orderStart,
        orderEnd,
        price,
        barberId,
        services,
      ];
}
