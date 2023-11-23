// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously, depend_on_referenced_packages

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../features/management/domain/entity/barber_entity.dart';
import '../../features/management/domain/entity/employee_entity.dart';
import '../../get_it/locator.dart';
import '../utils/responsive.dart';
import '../utils/storage_service.dart';
import 'data_mobile_view_widget.dart';
import 'empty_widget.dart';

class DataTableWithForm extends StatefulWidget {
  const DataTableWithForm({
    Key? key,
    required this.data,
    this.onTap,
    required this.onDelete,
    required this.pageCount,
    required this.screenKey,
    this.handleOnRowChecked,
    this.onChanged,
    this.isFormVisible = false,
    required this.isEmpty,
    this.form,
  }) : super(key: key);

  final List<dynamic> data;
  final Function(dynamic)? onChanged;

  final String screenKey;
  final Function(dynamic)? onTap;
  final int pageCount;
  final bool isFormVisible;
  final bool isEmpty;
  final Function(String) onDelete;
  final Widget? form;
  final Function(PlutoGridOnRowCheckedEvent)? handleOnRowChecked;

  // final Future<PlutoLazyPaginationResponse> Function(PlutoLazyPaginationRequest)
  // onFetch;

  @override
  State<DataTableWithForm> createState() => _DataTableWithFormState();
}

class _DataTableWithFormState extends State<DataTableWithForm> {
  late PlutoGridStateManager stateManager;
  late List<PlutoColumn> columns;
  late List<PlutoRow> rows;
  late PlutoRow? selectedRow;
  late StorageService storageService;
  late PlutoGridConfiguration configuration;
  Map<String, double> jsonSizes = {};

  @override
  void didChangeDependencies() {
    if (widget.data.length != widget.data.length ||
        widget.pageCount != widget.pageCount) {
      initialize();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    columns = [];
    rows = [];
    selectedRow = null;
    storageService = locator();

    initialize();
  }

  initialize() async {
    if (widget.data.isNotEmpty) {
      rows = List<PlutoRow>.from(widget.data.map((e) => e.getRow(e)));

      columns = widget.data.first.getColumn(
        (data) {
          widget.onDelete.call(data.id);
        },
      );
      await _getSizes();
    }
  }

  // _onSizeColumnChanged(String field, double size) {
  //   jsonSizes[field] = size;
  //   _saveSize(jsonSizes);
  // }

  _saveSize(Map<String, double> sizes) async {
    await storageService.save(
      key: widget.screenKey,
      value: sizes,
      boxKey: widget.screenKey,
    );
  }

  _getSizes() async {
    final data = await storageService.fetch(
      key: widget.screenKey,
      boxKey: widget.screenKey,
    );

    if (data == null) return null;

    debugPrint("data from storage $data");

    jsonSizes = Map<String, double>.from(data);
    return jsonSizes;
  }

  @override
  Widget build(BuildContext context) {
    configuration = context.locale.languageCode == 'uz'
        ? PlutoGridConfiguration(
            localeText: const PlutoGridLocaleText.russian(
              unfreezeColumn: "Ustunni muzdan tushiring",
              freezeColumnToStart: "Boshida ustunni o'rnating",
              freezeColumnToEnd: "Oxirida ustunni o'rnating",
              autoFitColumn: "Avtomatik ustun hajmi",
              hideColumn: "Ustunni yashirish",
              setColumns: "Karnaylarni o'rnating",
              setFilter: "Filtrlarni o'rnating",
              resetFilter: "Filtrlarni tiklash",
              setColumnsTitle: "Sarlavha ustunlarini o'rnating",
              filterColumn: "Karnaylarni filtrlash",
              filterType: "Filtr turi",
              filterValue: "Filtr qiymati",
              filterAllColumns: "Barcha karnaylarni filtrlang",
              filterContains: "Filtr mavjud",
              filterEquals: "Filtr Teng",
              filterStartsWith: "Filter bilan boshlanadi",
              filterEndsWith: "Filtr bilan tugaydi",
              filterGreaterThan: "Filtr kattaroq",
              filterGreaterThanOrEqualTo: "Dan katta yoki teng filtrlang",
              filterLessThan: "Kamroq filtrlang",
              filterLessThanOrEqualTo: "Dan kam yoki teng filtrlang",
              sunday: "yakshanba",
              monday: "dushanba",
              tuesday: "seshanba",
              wednesday: "chorshanba",
              thursday: "payshanba",
              friday: "juma",
              saturday: "shanba",
              hour: "soat",
              minute: "daqiqa",
              loadingText: "Matn Yuklanmoqda",
            ),

            /// If columnFilterConfig is not set, the default setting is applied.
            ///
            /// Return the value returned by resolveDefaultColumnFilter through the resolver function.
            /// Prevents errors returning filters that are not in the filters list.

            columnFilter: PlutoGridColumnFilterConfig(
              filters: const [
                ...FilterHelper.defaultFilters,
                // custom filter
              ],
              resolveDefaultColumnFilter: (column, resolver) {
                if (column.field == 'text') {
                  return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                } else if (column.field == 'number') {
                  return resolver<PlutoFilterTypeGreaterThan>()
                      as PlutoFilterType;
                } else if (column.field == 'date') {
                  return resolver<PlutoFilterTypeLessThan>() as PlutoFilterType;
                }

                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              },
            ),
          )
        : PlutoGridConfiguration(
            localeText: const PlutoGridLocaleText.russian(),

            /// If columnFilterConfig is not set, the default setting is applied.
            ///
            /// Return the value returned by resolveDefaultColumnFilter through the resolver function.
            /// Prevents errors returning filters that are not in the filters list.
            columnFilter: PlutoGridColumnFilterConfig(
              filters: const [
                ...FilterHelper.defaultFilters,
                // custom filter
              ],
              resolveDefaultColumnFilter: (column, resolver) {
                if (column.field == 'text') {
                  return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
                } else if (column.field == 'number') {
                  return resolver<PlutoFilterTypeGreaterThan>()
                      as PlutoFilterType;
                } else if (column.field == 'date') {
                  return resolver<PlutoFilterTypeLessThan>() as PlutoFilterType;
                }

                return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
              },
            ),
          );

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _desktopViewWithForm(),
        // child: Responsive.isMobile(context)
        //     ? widget.data.isEmpty
        //         ? const Center(child: EmptyWidget())
        //         : DataMobileViewWidget(
        //             data: List.of(widget.data),
        //             editData: (data) => widget.onTap?.call(data.getRow(data)),
        //             deleteData: (data) => widget.onDelete.call(data),
        //           )
        //     : _desktopViewWithForm(),
      ),
    );
  }

  _desktopViewWithForm() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: widget.isEmpty ? const EmptyWidget() : _desktopView(),
            flex: 2),
        if (widget.isFormVisible && widget.form != null)
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: widget.form,
            ),
          ),
      ],
    );
  }

  _desktopView() {
    return widget.data.isEmpty
        ? const Center(child: EmptyWidget())
        : PlutoGrid(
            columns: columns,
            rows: rows,
            onSizeChanged: (column, size) {
              jsonSizes[column.field] = size;
              debugPrint(
                  "Column field  ${column.field}, Size $size $jsonSizes");

              _saveSize(jsonSizes);
            },
            mode: PlutoGridMode.readOnly,
            onRowDoubleTap: (event) {
              selectedRow = event.row;
              widget.onTap?.call(event.row);
            },
            onLoaded: (PlutoGridOnLoadedEvent event) async {
              stateManager = event.stateManager;

              stateManager.setShowColumnFilter(false);
              stateManager.setIsDraggingRow(false);
              // stateManager.setPageSize(widget.pageCount);
              // stateManager.autoFitColumn(context, widget.columns.first);
              // stateManager.setShowColumnFilter(false, );

              // stateManager.removeColumnsInFilterRows([columns.first]);

              stateManager.setPageSize(
                widget.pageCount,
                notify: true,
              );

              await _setColumnSize(columns);
              // if (widget.jsonSizes != null) {
              //   _autoFitColumn(widget.jsonSizes!, columns);
              // }
              // _autoFitColumn(widget.columns);
              // _setCheckToZero(widget.columns);
            },
            onRowChecked: widget.handleOnRowChecked,
            onChanged: (PlutoGridOnChangedEvent event) =>
                widget.onChanged?.call(event.row),
            rowColorCallback: (rowColorContext) {
              if (selectedRow == rowColorContext.row) {
                return Colors.grey.shade100;
              }

              final data = rowColorContext.row;

              if (widget.data[0] is EmployeeEntity) {
                return _colorForEmployee(data.cells['isCurrentFilial']?.value);
              }
              if (widget.data[0] is BarberEntity) {
                return _colorForBarber(data.cells['isCurrentFilial']?.value, data.cells['isActive']?.value);
              }

              return Colors.white;
            },
            configuration: configuration,
          );
  }

  _colorForEmployee(bool isCurrentFilial) {
    if (isCurrentFilial == false) {
      return Colors.grey.shade300;
    }

    return Colors.white;
  }

  _colorForBarber(bool isCurrentFilial,bool isActive) {
    if (isCurrentFilial == false) {
      return Colors.grey.shade300;
    }
    if (isActive == false) {
      return Colors.grey.shade400;
    }

    return Colors.white;
  }

  _setColumnSize(List<PlutoColumn> columns) async {
    // stateManager.columnsResizeMode;

    final sizes = await _getSizes();

    PlutoColumn? columnItem;

    debugPrint("set risize $sizes");
    // debugPrint("Sizes $sizes");

    if (sizes != null) {
      sizes.forEach((field, size) {
        columnItem =
            columns.firstWhereOrNull((element) => element.field == field);

        if (columnItem != null) {
          stateManager.setColumnMinSize(columnItem!, size);
          // stateManager.resizeColumn(
          //   columnItem!,
          //   size,
          // );
        }

        columnItem = null;
      });
    }

    columnItem = null;

    if (mounted) {
      Future.delayed(
        Duration.zero,
        () {
          setState(() {});
        },
      );
    }
  }
}
