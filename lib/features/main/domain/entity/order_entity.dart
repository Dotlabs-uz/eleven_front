// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/entities/field_entity.dart';
import '../../../products/domain/entity/service_product_entity.dart';

enum OrderPayment {
  cash,
  card,
}

@immutable
class OrderEntity extends Equatable {
  final String id;
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
    required this.id,
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

  static Map<String, FieldEntity> fields = {
    "id": FieldEntity<String>(
      label: "id",
      hintText: "id",
      type: Types.string,
      isForm: true,
      val: "",
    ),
    "discount": FieldEntity<double>(
      label: "discount",
      hintText: "discount",
      type: Types.double,
      isRequired: true,
      isForm: true,
      val: 0,
    ),
    "discountPercent": FieldEntity<double>(
      label: "discountPercent",
      hintText: "discountPercent",
      type: Types.double,
      isRequired: true,
      isForm: true,
      val: 0,
    ),
    "paymentType": FieldEntity<OrderPayment>(
      label: "paymentType",
      hintText: "paymentType",
      type: Types.paymentType,
      isRequired: true,
      isForm: true,
      val: OrderPayment.cash,
    ),
    "price": FieldEntity<int>(
      label: "price",
      hintText: "price",
      type: Types.int,
      isRequired: true,
      isForm: true,
      val: 0,
    ),
    "orderStart": FieldEntity<DateTime>(
      label: "orderStart",
      hintText: "orderStart",
      type: Types.dateTime,
      isRequired: true,
      isForm: true,
      val: DateTime.now(),
    ),
    "orderEnd": FieldEntity<DateTime>(
      label: "orderEnd",
      hintText: "orderEnd",
      type: Types.dateTime,
      isRequired: true,
      isForm: true,
      val: DateTime.now(),
    ),
    "barber": FieldEntity<String>(
      label: "barberId",
      hintText: "barberId",
      type: Types.barber,
      isRequired: true,
      isForm: true,
      val: "",
    ),
    "client": FieldEntity<String>(
      label: "clientId",
      hintText: "clientId",
      type: Types.client,
      isRequired: true,
      isForm: true,
      val: "",
    ),
  };

  Map<String, FieldEntity> getFields() {
    fields.forEach((key, value) {
      value.val = getProp(key);
    });

    return fields;
  }

  dynamic getProp(String key) => <String, dynamic>{
        "id": id,
        "discount": discount,
        "discountPercent": discountPercent,
        "paymentType": paymentType,
        "orderStart": orderStart,
        "orderEnd": orderEnd,
        "price": price,
        "barber": barberId,
        "client": clientId,
      }[key];

  factory OrderEntity.fromRow(PlutoRow row) {
    return OrderEntity(
      id: row.cells["id"]?.value,
      discount: row.cells["discount"]?.value,
      discountPercent: row.cells["discountPercent"]?.value,
      paymentType: row.cells["paymentType"]?.value,
      orderStart: row.cells["orderStart"]?.value,
      orderEnd: row.cells["orderEnd"]?.value,
      price: row.cells["price"]?.value,
      barberId: row.cells["barber"]?.value,
      clientId: row.cells["client"]?.value,
      services: const [],
    );
  }

  PlutoRow getRow(OrderEntity e) {
    return PlutoRow(cells: {
      'delete': PlutoCell(value: "Delete"),
      'id': PlutoCell(value: e.id),
      'discount': PlutoCell(value: e.discount),
      'discountPercent': PlutoCell(value: e.discountPercent),
      'paymentType': PlutoCell(value: e.paymentType),
      'orderStart': PlutoCell(value: e.orderStart),
      'orderEnd': PlutoCell(value: e.orderEnd),
      'price': PlutoCell(value: e.price),
      'barber': PlutoCell(value: e.barberId),
      'client': PlutoCell(value: e.clientId),
    });
  }

  factory OrderEntity.fromFields() {
    return OrderEntity(
      id: fields["id"]?.val,
      discount: fields["discount"]?.val,
      discountPercent: fields["discountPercent"]?.val,
      paymentType: fields["paymentType"]?.val,
      orderStart: fields["orderStart"]?.val,
      orderEnd: fields["orderEnd"]?.val,
      price: fields["price"]?.val,
      barberId: fields["barber"]?.val,
      clientId: fields["client"]?.val,
      services: const [],
    );
  }

  factory OrderEntity.empty({int? hour, int? minute}) {
    return OrderEntity(
      id: "",
      discount: 0,
      discountPercent: 0,
      paymentType: OrderPayment.cash,
      orderStart: DateTime.now().copyWith(hour: hour, minute: minute),
      orderEnd: DateTime.now().add(const Duration(hours: 1)),
      price: 10,
      barberId: "",
      clientId: "",
      services: const [],
    );
  }

  @override
  List<Object?> get props => [
    id,
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
