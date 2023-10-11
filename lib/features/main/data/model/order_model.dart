// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/order_entity.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.title,
    required super.from,
    required super.to,
    required super.price,
    required super.employeeId,
    required super.services,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      title: json['title'],
      from: json['from'],
      to: json['to'],
      price: json['price'],
      employeeId: json['employee_id'],
      services: json['services'],
    );
  }


}
