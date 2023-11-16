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
  final OrderPayment paymentType;
  DateTime orderStart;
  DateTime orderEnd;
  String barberId;
  final String clientId;
  num price;
  num duration;
  bool isNew;
  final List<ServiceProductEntity> services;

  OrderEntity({
    required this.id,
    required this.paymentType,
    required this.orderStart,
    required this.orderEnd,
    required this.barberId,
    required this.isNew,
    required this.clientId,
    required this.services,
    required this.price,
    required this.duration,
  });

  static Map<String, FieldEntity> fields = {
    "id": FieldEntity<String>(
      label: "id",
      hintText: "id",
      type: Types.string,
      isForm: true,
      val: "",
    ),
    // "discount": FieldEntity<double>(
    //   label: "discount",
    //   hintText: "discount",
    //   type: Types.double,
    //   isRequired: true,
    //   isForm: true,
    //   val: 0,
    // ),
    // "discountPercent": FieldEntity<double>(
    //   label: "discountPercent",
    //   hintText: "discountPercent",
    //   type: Types.double,
    //   isRequired: true,
    //   isForm: true,
    //   val: 0,
    // ),
    "paymentType": FieldEntity<OrderPayment>(
      label: "paymentType",
      hintText: "paymentType",
      type: Types.paymentType,
      isRequired: true,
      isForm: true,
      val: OrderPayment.cash,
    ),
    // "price": FieldEntity<int>(
    //   label: "price",
    //   hintText: "price",
    //   type: Types.int,
    //   isRequired: false,
    //   isForm: false,
    //   val: 0,
    // ),
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
    "barberId": FieldEntity<String>(
      label: "barberId",
      hintText: "barberId",
      type: Types.barber,
      isRequired: true,
      isForm: true,
      val: "",
    ),
    "clientId": FieldEntity<String>(
      label: "clientId",
      hintText: "clientId",
      type: Types.client,
      isRequired: true,
      isForm: true,
      val: "",
    ),
    "services": FieldEntity<List<ServiceProductEntity>>(
      label: "services",
      hintText: "services",
      type: Types.choseServices,
      isRequired: true,
      isForm: true,
      val: [],
    ),
    "isNew": FieldEntity<bool>(
      label: "isNew",
      hintText: "isNew",
      type: Types.bool,
      isRequired: false,
      isForm: false,
      val: true,
    ),
    "price": FieldEntity<int>(
      label: "price",
      hintText: "price",
      type: Types.int,
      isRequired: false,
      isForm: false,
      val: 0,
    ),
    "duration": FieldEntity<int>(
      label: "duration",
      hintText: "duration",
      type: Types.int,
      isRequired: false,
      isForm: false,
      val: 0,
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
        // "discount": discount,
        // "discountPercent": discountPercent,
        "paymentType": paymentType,
        "orderStart": orderStart,
        "orderEnd": orderEnd,
        // "price": price,
        "barberId": barberId,
        "clientId": clientId,
        "services": services,
        "isNew": isNew,
        "duration": duration,
        "price": price,
      }[key];

  factory OrderEntity.fromRow(PlutoRow row) {
    return OrderEntity(
      id: row.cells["id"]?.value,
      // discount: row.cells["discount"]?.value,
      // discountPercent: row.cells["discountPercent"]?.value,
      paymentType: row.cells["paymentType"]?.value,
      orderStart: row.cells["orderStart"]?.value,
      orderEnd: row.cells["orderEnd"]?.value,
      // price: row.cells["price"]?.value,
      barberId: row.cells["barberId"]?.value,
      clientId: row.cells["clientId"]?.value,
      services: row.cells["services"]?.value,
      isNew: row.cells["isNew"]?.value,
      duration: row.cells["duration"]?.value,
      price: row.cells["price"]?.value,
    );
  }

  PlutoRow getRow(OrderEntity e) {
    return PlutoRow(cells: {
      'delete': PlutoCell(value: "Delete"),
      'id': PlutoCell(value: e.id),
      // 'discount': PlutoCell(value: e.discount),
      // 'discountPercent': PlutoCell(value: e.discountPercent),
      'paymentType': PlutoCell(value: e.paymentType),
      'orderStart': PlutoCell(value: e.orderStart),
      'orderEnd': PlutoCell(value: e.orderEnd),
      // 'price': PlutoCell(value: e.price),
      'barberId': PlutoCell(value: e.barberId),
      'clientId': PlutoCell(value: e.clientId),
      'services': PlutoCell(value: e.services),
      'isNew': PlutoCell(value: e.isNew),
    });
  }

  factory OrderEntity.fromFields(
      {List<ServiceProductEntity>? selectedServices,
      String? barber,
      String? client}) {
    print("Factory Fields services ${selectedServices}");
    return OrderEntity(
      id: fields["id"]?.val,
      // discount: fields["discount"]?.val,
      // discountPercent: fields["discountPercent"]?.val,
      paymentType: fields["paymentType"]?.val,
      orderStart: fields["orderStart"]?.val,
      orderEnd: fields["orderEnd"]?.val,
      // price: fields["price"]?.val,
      barberId: barber ?? fields["barberId"]?.val,
      clientId: client ?? fields["clientId"]?.val,
      isNew: fields["isNew"]?.val,
      services: selectedServices != null && selectedServices.isNotEmpty
          ? selectedServices
          : List.from(fields["services"]?.val),
      price: fields["price"]?.val, duration: fields["duration"]?.val,
    );
  }

  factory OrderEntity.fromFieldsWithSelectedServices(
      {required List<ServiceProductEntity> selectedServices,
        String? barber,
        String? client}) {
    return OrderEntity(
      id: fields["id"]?.val,
      // discount: fields["discount"]?.val,
      // discountPercent: fields["discountPercent"]?.val,
      paymentType: fields["paymentType"]?.val,
      orderStart: fields["orderStart"]?.val,
      orderEnd: fields["orderEnd"]?.val,
      // price: fields["price"]?.val,
      barberId: barber ?? fields["barberId"]?.val,
      clientId: client ?? fields["clientId"]?.val,
      isNew: fields["isNew"]?.val,
      services: selectedServices,
      price: fields["price"]?.val, duration: fields["duration"]?.val,
    );
  }

  factory OrderEntity.empty(
      {int? hour, int? minute, String? barber, int? day, int? month}) {
    final dateTime = DateTime.now()
        .copyWith(hour: hour, minute: minute, day: day, month: month);
    return OrderEntity(
      id: "",
      // discount: 0,
      // discountPercent: 0,
      paymentType: OrderPayment.cash,
      orderStart: dateTime,
      orderEnd: dateTime.add(const Duration(hours: 1)),
      // price: 0,
      barberId: barber ?? "",
      clientId: "",
      isNew: true,
      services: const [], price: 0, duration: 0,
    );
  }

  @override
  List<Object?> get props => [
        id,
      ];
}
