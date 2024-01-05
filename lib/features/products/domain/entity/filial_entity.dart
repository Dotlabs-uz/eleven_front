import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/entities/field_entity.dart';

class FilialEntity extends Equatable {
  final String id;
  final int phone;
  final String name;
  final String address;

  const FilialEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  static Map<String, FieldEntity> fields = {
    "id": FieldEntity<String>(
      label: "id",
      hintText: "id",
      type: Types.string,
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
    "phone": FieldEntity<int>(
      label: "phone",
      hintText: "phone",
      type: Types.int,
      isRequired: true,
      isForm: true,
      val: 99,
    ),
    "address": FieldEntity<String>(
      label: "address",
      hintText: "address",
      type: Types.string,
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
        "name": name,
        "phone": phone,
        "address": address,
      }[key];

  factory FilialEntity.fromRow(PlutoRow row) {
    return FilialEntity(
      id: row.cells["id"]?.value,
      name: row.cells["name"]?.value,
      phone: row.cells["phone"]?.value,
      address: row.cells["address"]?.value,
    );
  }

  PlutoRow getRow(FilialEntity e) {
    return PlutoRow(cells: {
      'delete': PlutoCell(value: "Delete"),
      'id': PlutoCell(value: e.id),
      'name': PlutoCell(value: e.name),
      'phone': PlutoCell(value: e.phone),
      'address': PlutoCell(value: e.address),
    });
  }

  List<PlutoColumn> getColumn(Function(FilialEntity data) onDelete) {
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
              FilialEntity.fromRow(rendererContext.row),
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
        title: 'phone'.tr(),
        field: 'phone',
        readOnly: false,
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'filial'.tr(),
        field: 'filial',
        readOnly: false,
        type: PlutoColumnType.text(),
      ),
    ];
  }

  factory FilialEntity.fromFields() {
    return FilialEntity(
      id: fields["id"]?.val,
      name: fields["name"]?.val,
      phone: fields["phone"]?.val,
      address: fields["address"]?.val,
    );
  }

  factory FilialEntity.empty() {
    return const FilialEntity(
      id: "",
      name: "",
      address: "",
      phone:99,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        phone,
      ];
}
