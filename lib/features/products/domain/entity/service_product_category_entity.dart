import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../core/entities/field_entity.dart';

class ServiceProductCategoryEntity extends Equatable {
  final String id;
  final String name;

  const ServiceProductCategoryEntity({
    required this.id,
    required this.name,
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
  }[key];

  factory ServiceProductCategoryEntity.fromRow(PlutoRow row) {
    return ServiceProductCategoryEntity(
      id: row.cells["id"]?.value,
      name: row.cells["name"]?.value,
    );
  }

  PlutoRow getRow(ServiceProductCategoryEntity e) {
    return PlutoRow(cells: {
      'delete': PlutoCell(value: "Delete"),
      'id': PlutoCell(value: e.id),
      'name': PlutoCell(value: e.name),
    });
  }

  List<PlutoColumn> getColumn(Function(ServiceProductCategoryEntity data) onDelete) {
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
              ServiceProductCategoryEntity.fromRow(rendererContext.row),
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
        title: 'name'.tr(),
        field: 'name',
        readOnly: false,
        type: PlutoColumnType.text(),
      ),

    ];
  }



  factory ServiceProductCategoryEntity.fromFields() {
    return ServiceProductCategoryEntity(
      id: fields["id"]?.val,
      name: fields["name"]?.val,
    );
  }

  factory ServiceProductCategoryEntity.empty() {
    return const ServiceProductCategoryEntity(
      id: "",
      name: "",
    );
  }




  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
