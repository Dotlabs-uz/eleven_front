import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/components/datetime_for_table_widget.dart';
import '../../../../core/entities/field_entity.dart';
import 'employee_schedule_entity.dart';

class BarberEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String password;
  final String login;
  final String phoneNumber;
  final String filialId;

  const BarberEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.login,
    required this.phoneNumber,
    required this.filialId,
  });

  static Map<String, FieldEntity> fields = {
    "id": FieldEntity<String>(
      label: "id",
      hintText: "id",
      type: Types.string,
      isForm: true,
      val: "",
    ),
    "firstName": FieldEntity<String>(
      label: "firstName",
      hintText: "firstName",
      type: Types.string,
      isRequired: true,
      isForm: true,
      val: "",
    ),
    "lastName": FieldEntity<String>(
      label: "lastName",
      hintText: "lastName",
      type: Types.string,
      isRequired: true,
      isForm: true,
      val: "",
    ),
    "password": FieldEntity<String>(
      label: "password",
      hintText: "password",
      type: Types.string,
      isRequired: true,
      isForm: true,
      val: "",
    ),
    "login": FieldEntity<String>(
      label: "login",
      hintText: "login",
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
  };

  Map<String, FieldEntity> getFields() {
    fields.forEach((key, value) {
      value.val = getProp(key);
    });

    return fields;
  }

  dynamic getProp(String key) => <String, dynamic>{
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
      }[key];

  factory BarberEntity.fromRow(PlutoRow row) {
    return BarberEntity(
      id: row.cells["id"]?.value,
      firstName: row.cells["fullName"]?.value,
      lastName: row.cells["lastName"]?.value,
      phoneNumber: row.cells["phoneNumber"]?.value,
      filialId: row.cells["filialId"]?.value,
      password: row.cells["password"]?.value,
      login: row.cells["login"]?.value,
    );
  }

  PlutoRow getRow(BarberEntity e) {
    return PlutoRow(cells: {
      'delete': PlutoCell(value: "Delete"),
      'id': PlutoCell(value: e.id),
      'firstName': PlutoCell(value: e.firstName),
      'lastName': PlutoCell(value: e.lastName),
      'phoneNumber': PlutoCell(value: e.phoneNumber),
      'filialId': PlutoCell(value: e.filialId),
      'password': PlutoCell(value: e.password),
      'login': PlutoCell(value: e.login),
    });
  }

  List<PlutoColumn> getColumn(Function(BarberEntity data) onDelete) {
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
              BarberEntity.fromRow(rendererContext.row),
            ),
          );
        },
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'firstName'.tr(),
        field: 'firstName',
        readOnly: false,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'lastName'.tr(),
        field: 'lastName',
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
    ];
  }

  factory BarberEntity.fromFields() {
    return BarberEntity(
      id: fields["id"]?.val,
      firstName: fields["firstName"]?.val,
      lastName: fields["lastName"]?.val,
      phoneNumber: fields["phoneNumber"]?.val,
      filialId: fields["filialId"]?.val,
      login: fields["login"]?.val,
      password: fields["password"]?.val,
    );
  }

  factory BarberEntity.empty() {
    return const BarberEntity(
      id: "",
      firstName: "",
      lastName: "",
      phoneNumber: "",
      filialId: "",
      password: "",
      login: "",
    );
  }

  @override
  List<Object?> get props => [id];
}
