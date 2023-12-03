// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/management/domain/entity/customer_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/entities/field_entity.dart';
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
