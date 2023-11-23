// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/management/domain/entity/weekly_schedule_results_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/components/datetime_for_table_widget.dart';
import '../../../../core/entities/field_entity.dart';
import '../../../products/domain/entity/filial_entity.dart';
import 'employee_schedule_entity.dart';
import 'not_working_hours_entity.dart';

@immutable
class BarberEntity extends Equatable {
  final String id;
  final String employeeId;
  final String firstName;
  final String lastName;
  final String password;
  final String avatar;
  final String login;
  final int phone;
  final bool isActive;
  final bool isOnline;
  bool inTimeTable;
  final bool isCurrentFilial;
  final List<NotWorkingHoursEntity> notWorkingHours;
  final FilialEntity filial;
  final WeeklyScheduleResultsEntity weeklySchedule;

  BarberEntity({
    required this.id,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.isActive,
    required this.isOnline,
    required this.password,
    required this.login,
    required this.phone,
    required this.notWorkingHours,
    required this.inTimeTable,
    required this.isCurrentFilial,
    required this.filial,
    required this.weeklySchedule,
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
    "employeeId": FieldEntity<String>(
      label: "employeeId",
      hintText: "employeeId",
      type: Types.string,
      isRequired: false,
      isForm: false,
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
    "avatar": FieldEntity<String>(
      label: "avatar",
      hintText: "avatar",
      type: Types.string,
      isRequired: false,
      isForm: false,
      val: "",
    ),
    "phone": FieldEntity<int>(
      label: "phoneNumber",
      hintText: "phoneNumber",
      type: Types.phoneNumber,
      isRequired: true,
      isForm: true,
      val: 99,
    ),
    "isCurrentFilial": FieldEntity<bool>(
      label: "isCurrentFilial",
      hintText: "isCurrentFilial",
      type: Types.bool,
      isRequired: false,
      isForm: false,
      val: false,
    ),
    "isActive": FieldEntity<bool>(
      label: "isActive",
      hintText: "isActive",
      type: Types.bool,
      isRequired: false,
      isForm: false,
      val: false,
    ),
    "isOnline": FieldEntity<bool>(
      label: "isOnline",
      hintText: "isOnline",
      type: Types.bool,
      isRequired: false,
      isForm: false,
      val: false,
    ),
    "filial": FieldEntity<FilialEntity>(
      label: "filial",
      hintText: "filial",
      type: Types.filial,
      isRequired: true,
      isForm: true,
      val: FilialEntity.empty(),
    ),
    "weeklySchedule": FieldEntity<WeeklyScheduleResultsEntity>(
      label: "weeklySchedule",
      hintText: "weeklySchedule",
      type: Types.weeklySchedule,
      isRequired: false,
      isForm: false,
      val: WeeklyScheduleResultsEntity.empty(),
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
        "employeeId": employeeId,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "weeklySchedule": weeklySchedule,
        "filial": filial,
        "password": password,
        "isCurrentFilial": isCurrentFilial,
        "isOnline": isOnline,
        "isActive": isActive,
        "avatar": avatar,
        "login": login,
      }[key];

  factory BarberEntity.fromRow(PlutoRow row) {
    return BarberEntity(
      id: row.cells["id"]?.value,
      employeeId: row.cells["employeeId"]?.value,
      firstName: row.cells["firstName"]?.value,
      lastName: row.cells["lastName"]?.value,
      phone: row.cells["phone"]?.value,
      filial: row.cells["filial"]?.value,
      avatar: row.cells["avatar"]?.value,
      isActive: row.cells["isActive"]?.value,
      isOnline: row.cells["isOnline"]?.value,
      isCurrentFilial: row.cells["isCurrentFilial"]?.value,
      weeklySchedule: row.cells["weeklySchedule"]?.value,
      // password: row.cells["password"]?.value,
      password: "",
      login: row.cells["login"]?.value, inTimeTable: false, notWorkingHours: [],
    );
  }

  PlutoRow getRow(BarberEntity e) {
    return PlutoRow(cells: {
      'delete': PlutoCell(value: "Delete"),
      'id': PlutoCell(value: e.id),
      'employeeId': PlutoCell(value: e.employeeId),
      'firstName': PlutoCell(value: e.firstName),
      'lastName': PlutoCell(value: e.lastName),
      'phone': PlutoCell(value: e.phone),
      'avatar': PlutoCell(value: e.avatar),
      'filial': PlutoCell(value: e.filial),
      'password': PlutoCell(value: e.password),
      'isOnline': PlutoCell(value: e.isOnline),
      'isActive': PlutoCell(value: e.isActive),
      'isCurrentFilial': PlutoCell(value: e.isCurrentFilial),
      'weeklySchedule': PlutoCell(value: e.weeklySchedule),
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
        title: 'login'.tr(),
        field: 'login',
        readOnly: false,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'phoneNumber'.tr(),
        field: 'phone',
        readOnly: false,
        type: PlutoColumnType.number(
          format: "",
          allowFirstDot: false,
        ),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'isActive'.tr(),
        field: 'isActive',
        readOnly: false,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'isOnline'.tr(),
        field: 'isOnline',
        readOnly: false,
        type: PlutoColumnType.text(),
      ),
    ];
  }

  factory BarberEntity.fromFields() {
    return BarberEntity(
      id: fields["id"]?.val,
      employeeId: fields["employeeId"]?.val,
      firstName: fields["firstName"]?.val,
      lastName: fields["lastName"]?.val,
      phone: fields["phone"]?.val,
      filial: fields["filial"]?.val,
      login: fields["login"]?.val,
      password: fields["password"]?.val,
      weeklySchedule: fields["weeklySchedule"]?.val,
      avatar: fields["avatar"]?.val,
      isCurrentFilial: fields["isCurrentFilial"]?.val,
      inTimeTable: false,
      isOnline: false,
      isActive: false,
      notWorkingHours: [],
    );
  }

  factory BarberEntity.empty() {
    return BarberEntity(
      id: "",
      employeeId: "",
      firstName: "",
      lastName: "",
      phone: 99,
      filial: FilialEntity.empty(),
      password: "",
      login: "",
      inTimeTable: false,
      isActive: false,
      isOnline: false,
      notWorkingHours: [],
      avatar: '',
      isCurrentFilial: false,
      weeklySchedule: WeeklyScheduleResultsEntity.empty(),
    );
  }

  @override
  List<Object?> get props => [id];
}
