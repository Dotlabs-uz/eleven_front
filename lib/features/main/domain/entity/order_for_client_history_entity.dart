// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../products/domain/entity/service_product_entity.dart';
@immutable
class OrderForClientEntity extends Equatable {

  final String barberName;
  final int barberPhone;
  final DateTime createdAt;
  final num price;
  final num duration;
  final bool fromSite;
  final List<ServiceProductEntity> services;

  const OrderForClientEntity({
    required this.barberName,
    required this.barberPhone,
    required this.createdAt,
    required this.fromSite,
    required this.services,
    required this.price,
    required this.duration,
  });



  @override
  List<Object?> get props => [
        createdAt,
      ];
}
