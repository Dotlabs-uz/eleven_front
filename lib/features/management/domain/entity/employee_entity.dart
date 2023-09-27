import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/components/datetime_for_table_widget.dart';
import '../../../../core/entities/field_entity.dart';
import 'employee_schedule_entity.dart';

class EmployeeEntity extends Equatable {

  final int id;
  final String fullName;
  final String createdAt;
  final String phoneNumber;
  final String shopName;
  final List<EmployeeScheduleEntity> schedule;

  const EmployeeEntity({
    required this.id,
    required this.fullName,
    required this.createdAt,
    required this.phoneNumber,
    required this.shopName,
    required this.schedule,
  });




  static Map<String, FieldEntity> fields = {
    "id": FieldEntity<int>(
      label: "id",
      hintText: "id",
      type: Types.int,
      isForm: true,
      val: 0,
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
    "shopName": FieldEntity<String>(
      label: "shopName",
      hintText: "shopName",
      type: Types.string,
      isForm: true,
      isRequired: true,
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
    "fullName": fullName,
    "phoneNumber": phoneNumber,
    "shopName": shopName,
  }[key];

  factory EmployeeEntity.fromRow(PlutoRow row) {
    return EmployeeEntity(
      id: row.cells["id"]?.value,
      fullName: row.cells["fullName"]?.value,
      createdAt: row.cells["createdAt"]?.value,
      phoneNumber: row.cells["phoneNumber"]?.value,
      shopName: row.cells["shopName"]?.value,
  schedule: [],
    );
  }

  PlutoRow getRow(EmployeeEntity e) {
    return PlutoRow(cells: {
      'delete': PlutoCell(value: "Delete"),
      'id': PlutoCell(value: e.id),
      'fullName': PlutoCell(value: e.fullName),
      'createdAt': PlutoCell(value: e.createdAt),
      'phoneNumber': PlutoCell(value: e.phoneNumber),
      'shopName': PlutoCell(value: e.shopName),
    });
  }

  List<PlutoColumn> getColumn(Function(EmployeeEntity data) onDelete) {
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
              EmployeeEntity.fromRow(rendererContext.row),
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
        type: PlutoColumnType.number(),
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
        title: 'createdAt'.tr(),
        field: 'createdAt',
        readOnly: true,
        renderer: (rendererContext) =>
            DateTimeForTableWidget(data: rendererContext),
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
        title: 'shopName'.tr(),
        field: 'shopName',
        readOnly: false,
        type: PlutoColumnType.text(),
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

  factory EmployeeEntity.fromFields() {
    return EmployeeEntity(
      id: fields["id"]?.val,
      fullName: fields["fullName"]?.val,
      phoneNumber: fields["phoneNumber"]?.val,
      shopName: fields["shopName"]?.val,
      createdAt: '',
      schedule: [],
    );
  }

  factory EmployeeEntity.empty() {
    return const EmployeeEntity(
      id: 0,
      fullName: "",
      phoneNumber: "",
      shopName: "",
      createdAt: "",
      schedule: [],
    );
  }

  @override
  List<Object?> get props => [id];
}
