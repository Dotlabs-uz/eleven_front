import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/entities/field_entity.dart';
import 'service_product_category_entity.dart';

class ServiceProductEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final double duration;
  final ServiceProductCategoryEntity category;
  final List<String> listBarberId;
  final String sex;

  const ServiceProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.category,
    required this.listBarberId,
    required this.sex,
  });

  static Map<String, FieldEntity> fields = {
    "id": FieldEntity<String>(
      label: "id",
      hintText: "id",
      type: Types.int,
      isForm: true,
      val: "",
    ),
    "name": FieldEntity<String>(
      label: "name",
      hintText: "name",
      type: Types.string,
      isRequired: true,
      isForm: true,
      val: "",
    ),
    "price": FieldEntity<double>(
      label: "price",
      hintText: "price",
      type: Types.double,
      isRequired: true,
      isForm: true,
      val: 0,
    ),
    "duration": FieldEntity<double>(
      label: "duration",
      hintText: "duration",
      type: Types.double,
      isForm: true,
      isRequired: true,
      val: 0,
    ),
    "category": FieldEntity<ServiceProductCategoryEntity>(
      label: "category",
      hintText: "category",
      type: Types.serviceCategory,
      isForm: true,
      isRequired: false,
      val: ServiceProductCategoryEntity.empty(),
    ),
    "listBarberId": FieldEntity<List<String>>(
      label: "listBarberId",
      hintText: "listBarberId",
      type: Types.barberMultiSelectId,
      isForm: true,
      isRequired: false,
      val: [],
    ),
    "sex": FieldEntity<String>(
      label: "sex",
      hintText: "sex",
      type: Types.sex,
      isForm: true,
      isRequired: true,
      val: "men",
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
        "name": name,
        "price": price,
        "duration": duration,
        "category": category,
        "listBarberId": listBarberId,
        "sex": sex,
      }[key];

  factory ServiceProductEntity.fromRow(PlutoRow row) {
    return ServiceProductEntity(
      id: row.cells["id"]?.value,
      name: row.cells["name"]?.value,
      price: row.cells["price"]?.value,
      duration: row.cells["duration"]?.value,
      category: row.cells["category"]?.value,
      sex: row.cells["sex"]?.value,
      listBarberId: row.cells["listBarberId"]?.value,
    );
  }

  PlutoRow getRow(ServiceProductEntity e) {
    return PlutoRow(cells: {
      'delete': PlutoCell(value: "Delete"),
      'id': PlutoCell(value: e.id),
      'name': PlutoCell(value: e.name),
      'price': PlutoCell(value: e.price),
      'duration': PlutoCell(value: e.duration),
      'category': PlutoCell(value: e.category),
      'categoryName': PlutoCell(value: e.category),
      'listBarberId': PlutoCell(value: e.listBarberId),
      'sex': PlutoCell(value: e.sex),
    });
  }

  List<PlutoColumn> getColumn(Function(ServiceProductEntity data) onDelete) {
    return [
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'delete'.tr(),
        field: 'delete',
        frozen: PlutoColumnFrozen.start,
        readOnly: true,
        enableAutoEditing: false,
        enableContextMenu: false,
        enableSorting: false,
        enableRowChecked: false,
        enableFilterMenuItem: false,
        enableEditingMode: false,
        width: 60,
        enableDropToResize: true,
        renderer: (rendererContext) {
          return IconButton(
            icon: Icon(
              Icons.delete_rounded,
              size: 16,
              color: rendererContext.cell.row.cells['status']?.value == 4
                  ? Colors.white
                  : Colors.red,
            ),
            onPressed: () => onDelete.call(
              ServiceProductEntity.fromRow(rendererContext.row),
            ),
          );
        },
        type: PlutoColumnType.text(),
      ),
      //PlutoColumn(
      //enableColumnDrag: false,
      //enableRowDrag: false,
      //title: 'id'.tr(),
      //field: 'id',
      //enableRowChecked: false,
      //readOnly: true,
      // enableDropToResize: true,
      // type: PlutoColumnType.text(),
      // ),
      // PlutoColumn(
      //   enableColumnDrag: false,
      //   enableRowDrag: false,
      //   title: 'organisation'.tr(),
      //   field: 'organisation',
      //   type: PlutoColumnType.text(),
      // ),
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'name'.tr(),
        field: 'name',
        readOnly: false,
        type: PlutoColumnType.text(),
      ),

      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'categoryName'.tr(),
        field: 'categoryName',
        readOnly: false,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          if (rendererContext.cell.value != null &&
              rendererContext.cell.value.toString().isNotEmpty) {
            return Text(
              "${rendererContext.cell.value.name}",
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            );
          }

          return Text("noData".tr());
        },
      ),

      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'price'.tr(),
        field: 'price',
        readOnly: false,
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'duration'.tr(),
        field: 'duration',
        readOnly: false,
        type: PlutoColumnType.number(),
        renderer: (rendererContext) {
          if (rendererContext.cell.value != null &&
              rendererContext.cell.value.toString().isNotEmpty) {
            return Text(
              "${rendererContext.cell.value} ${"min".tr()}",
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            );
          }

          return Text("noData".tr());
        },
      ),
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'sex'.tr(),
        field: 'sex',
        readOnly: false,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          if (rendererContext.cell.value != null &&
              rendererContext.cell.value.toString().isNotEmpty) {
            return Text(
              (rendererContext.cell.value.toString().tr()),
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            );
          }

          return Text("noData".tr());
        },
      ),
      // PlutoColumn(
      //   enableColumnDrag: false,
      //   enableRowDrag: false,
      //   title: 'isOrganisation'.tr(),
      //   field: 'isOrganisation',
      //   readOnly: true,
      //   renderer: (rendererContext) =>
      //       BoolForTableWidget(data: rendererContext),
      //   type: PlutoColumnType.text(),
      // ),
    ];
  }

  factory ServiceProductEntity.fromFields() {
    return ServiceProductEntity(
      id: fields["id"]?.val,
      name: fields["name"]?.val,
      price: fields["price"]?.val,
      duration: fields["duration"]?.val,
      category: fields["category"]?.val,
      sex: fields["sex"]?.val,
      listBarberId: fields["listBarberId"]?.val,
    );
  }

  factory ServiceProductEntity.empty() {
    return ServiceProductEntity(
      id: "",
      name: "",
      price: 0,
      duration: 0,
      category: ServiceProductCategoryEntity.empty(),
      sex: "men",
      listBarberId: [],
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        listBarberId.length,
      ];
}
