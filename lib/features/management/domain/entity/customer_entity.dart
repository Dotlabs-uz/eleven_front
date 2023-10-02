import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/entities/field_entity.dart';

class CustomerEntity extends Equatable {

  final String id;
  final String fullName;
  final String phoneNumber;
  final int ordersCount;

  const CustomerEntity({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.ordersCount,
  });




  static Map<String, FieldEntity> fields = {
    "id": FieldEntity<String>(
      label: "id",
      hintText: "id",
      type: Types.string,
      isForm: true,
      val: "",
    ),
    "fullName": FieldEntity<String>(
      label: "fullName",
      hintText: "fullName",
      type: Types.string,
      isRequired: true,
      isForm: true,
      val: "",
    ),
    "phoneNumber": FieldEntity<String>(
      label: "phoneNumber",
      hintText: "phoneNumber",
      type: Types.string,
      isRequired: true,
      isForm: true,
      val: "",
    ),
    "ordersCount": FieldEntity<int>(
      label: "ordersCount",
      hintText: "ordersCount",
      type: Types.string,
      isForm: false,
      isRequired: false,
      val:0,
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
    "fullName": fullName,
    "phoneNumber": phoneNumber,
    "ordersCount": ordersCount,
  }[key];

  factory CustomerEntity.fromRow(PlutoRow row) {
    return CustomerEntity(
      id: row.cells["id"]?.value,
      fullName: row.cells["fullName"]?.value,
      phoneNumber: row.cells["phoneNumber"]?.value,
      ordersCount: row.cells["ordersCount"]?.value,

    );
  }

  PlutoRow getRow(CustomerEntity e) {
    return PlutoRow(cells: {
      'delete': PlutoCell(value: "Delete"),
      'id': PlutoCell(value: e.id),
      'fullName': PlutoCell(value: e.fullName),
      'phoneNumber': PlutoCell(value: e.phoneNumber),
      'ordersCount': PlutoCell(value: e.ordersCount),
    });
  }

  List<PlutoColumn> getColumn(Function(CustomerEntity data) onDelete) {
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
              CustomerEntity.fromRow(rendererContext.row),
            ),
          );
        },
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'id'.tr(),
        field: 'id',
        enableRowChecked: false,
        readOnly: true,
        // enableDropToResize: true,
        type: PlutoColumnType.text(),
      ),
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
        title: 'fullName'.tr(),
        field: 'fullName',
        readOnly: false,
        type: PlutoColumnType.text(),
      ),

      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'phoneNumber'.tr(),
        field: 'phoneNumber',
        readOnly: false,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'ordersCount'.tr(),
        field: 'ordersCount',
        readOnly: false,
        type: PlutoColumnType.number(),
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

  factory CustomerEntity.fromFields() {
    return CustomerEntity(
      id: fields["id"]?.val,
      fullName: fields["fullName"]?.val,
      phoneNumber: fields["phoneNumber"]?.val,
      ordersCount: fields["ordersCount"]?.val,
    );
  }

  factory CustomerEntity.empty() {
    return const CustomerEntity(
      id: "",
      fullName: "",
      phoneNumber: "",
      ordersCount:0,
    );
  }

  @override
  List<Object?> get props => [id];
}
