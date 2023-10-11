// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../products/domain/entity/service_product_entity.dart';

@immutable
class OrderEntity extends Equatable {
  final String title;
  final int price;
  DateTime from;
  final DateTime to;
  String employeeId;
  final List<ServiceProductEntity> services;

  OrderEntity({
    required this.title,
    required this.from,
    required this.to,
    required this.price,
    required this.employeeId,
    required this.services,
  });

  @override
  List<Object?> get props => [
        title,
        from,
        to,
        price,
        employeeId,
    services,
      ];
}
