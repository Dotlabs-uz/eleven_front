import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/entities/field_entity.dart';

class ManagerEntity extends Equatable {

  final String id;
  final String firstName;
  final String lastName;
  final String password;
  final String login;
  final int phone;
  final String role;

  const ManagerEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.login,
    required this.phone,
    required this.role,
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
    "phone": FieldEntity<int>(
      label: "phoneNumber",
      hintText: "phoneNumber",
      type: Types.phoneNumber,
      isRequired: true,
      isForm: true,
      val: 998,
    ),
    "role": FieldEntity<String>(
      label: "role",
      hintText: "role",
      type: Types.roleForManagers,
      isRequired: false,
      isForm: false,
      val: "managers",
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
        "phone": phone,
        "role": role,
        "password": password,
        "login": login,
      }[key];

  factory ManagerEntity.fromRow(PlutoRow row) {
    return ManagerEntity(
      id: row.cells["id"]?.value,
      firstName: row.cells["firstName"]?.value,
      lastName: row.cells["lastName"]?.value,
      phone: row.cells["phone"]?.value,
      role: row.cells["role"]?.value,
      // password: row.cells["password"]?.value,
      password: "",
      login: row.cells["login"]?.value,
    );
  }

  PlutoRow getRow(ManagerEntity e) {
    return PlutoRow(cells: {
      'delete': PlutoCell(value: "Delete"),
      'id': PlutoCell(value: e.id),
      'firstName': PlutoCell(value: e.firstName),
      'lastName': PlutoCell(value: e.lastName),
      'phone': PlutoCell(value: e.phone),
      'role': PlutoCell(value: e.role),
      'password': PlutoCell(value: e.password),
      'login': PlutoCell(value: e.login),
    });
  }

  List<PlutoColumn> getColumn(Function(ManagerEntity data) onDelete) {
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
              ManagerEntity.fromRow(rendererContext.row),
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
        title: 'login'.tr(),
        field: 'login',
        readOnly: false,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'role'.tr(),
        field: 'role',
        readOnly: false,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'phoneNumber'.tr(),
        field: 'phone',
        readOnly: false,
        type: PlutoColumnType.number(format: "",allowFirstDot: false,),
      ),
    ];
  }

  factory ManagerEntity.fromFields() {
    return ManagerEntity(
      id: fields["id"]?.val,
      firstName: fields["firstName"]?.val,
      lastName: fields["lastName"]?.val,
      phone: fields["phone"]?.val,
      role: fields["role"]?.val,
      login: fields["login"]?.val,
      password: fields["password"]?.val,
    );
  }

  factory ManagerEntity.empty() {
    return   ManagerEntity(
      id: "",
      firstName: "",
      lastName: "",
      phone: 99,
      role: "managers",
      password: "",
      login: "",
    );
  }

  @override
  List<Object?> get props => [id];
}
