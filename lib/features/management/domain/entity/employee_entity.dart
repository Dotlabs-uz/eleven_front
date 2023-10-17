import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/entities/field_entity.dart';
import 'employee_schedule_entity.dart';


class EmployeeEntity extends Equatable {

  final String id;
  final String firstName;
  final String lastName;
  final String role;
  final int phoneNumber;
  final List<EmployeeScheduleEntity> schedule;

  const EmployeeEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.phoneNumber,
    required this.schedule,
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
    ),    "lastName": FieldEntity<String>(
      label: "lastName",
      hintText: "lastName",
      type: Types.string,
      isRequired: true,
      isForm: true,
      val: "",
    ),
    "role": FieldEntity<String>(
      label: "role",
      hintText: "role",
      type: Types.string,
      isRequired: true,
      isForm: true,
      val: "",
    ),
    "phone": FieldEntity<int>(
      label: "phoneNumber",
      hintText: "phoneNumber",
      type: Types.int,
      isForm: true,
      isRequired: true,
      val: 99,
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
    "role": role,
    "phone": phoneNumber,
  }[key];

  factory EmployeeEntity.fromRow(PlutoRow row) {
    return EmployeeEntity(
      id: row.cells["id"]?.value,
      firstName: row.cells["firstName"]?.value,
      lastName: row.cells["lastName"]?.value,
      phoneNumber: row.cells["phone"]?.value,
      role: row.cells["role"]?.value,
  schedule: [],
    );
  }

  PlutoRow getRow(EmployeeEntity e) {
    return PlutoRow(cells: {
      'delete': PlutoCell(value: "Delete"),
      'id': PlutoCell(value: e.id),
      'firstName': PlutoCell(value: e.firstName),
      'lastName': PlutoCell(value: e.lastName),
      'phone': PlutoCell(value: e.phoneNumber),
      'role': PlutoCell(value: e.role),
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
        title: 'firstName'.tr(),
        field: 'firstName',
        readOnly: true,
        type: PlutoColumnType.text(),
      ),PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'lastName'.tr(),
        field: 'lastName',
        readOnly: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'phoneNumber'.tr(),
        field: 'phone',
        readOnly: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        enableColumnDrag: false,
        enableRowDrag: false,
        title: 'role'.tr(),
        field: 'role',
        readOnly: false,
        renderer: (rendererContext) {
          if (rendererContext.cell.value != null &&
              rendererContext.cell.value.toString().isNotEmpty) {
            return Text(
              (rendererContext.cell.value.toString().tr() ),
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            );
          }

          return Text("noData".tr());
        },

        type: PlutoColumnType.text(),
      ),
    ];
  }

  factory EmployeeEntity.fromFields() {
    return EmployeeEntity(
      id: fields["id"]?.val,
      firstName: fields["firstName"]?.val,
      lastName: fields["lastName"]?.val,
      phoneNumber: fields["phone"]?.val,
      role: fields["role"]?.val,
      schedule: [],
    );
  }

  factory EmployeeEntity.empty() {
    return const EmployeeEntity(
      id: "",
      firstName: "",
      lastName: "",
      phoneNumber: 99,
      role: "",
      schedule: [],
    );
  }

  @override
  List<Object?> get props => [id];
}
