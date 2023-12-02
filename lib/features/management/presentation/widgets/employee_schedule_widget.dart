import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/utils/constants.dart';
import 'package:eleven_crm/core/utils/dialogs.dart';
import 'package:eleven_crm/features/management/domain/entity/employee_schedule_entity.dart';
import 'package:eleven_crm/features/management/presentation/provider/cross_in_employee_schedule_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:region_detector/region_detector.dart';

import '../../../../core/utils/color_helper.dart';
import '../../../../core/utils/string_helper.dart';
import '../../domain/entity/employee_entity.dart';
import 'month_selector_with_dates_widget.dart';

import 'package:flutter/material.dart';

class FieldSchedule extends Equatable {
  final DateTime? dateTime;
  final String employeeId;
  late int status;

  FieldSchedule(this.dateTime, this.employeeId, this.status);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (dateTime != null) {
      data['date'] = dateTime!.toIso8601String();
    }
    data['employee'] = employeeId;
    data['status'] = status;
    return data;
  }

  @override
  List<Object?> get props => [
        dateTime?.day,
        dateTime?.month,
        dateTime?.year,
        employeeId,
      ];
}

class EmployeeScheduleWidget extends StatefulWidget {
  final Function(int)? onMonthChanged;
  final List<EmployeeEntity> listEmployee;
  final Function(List<FieldSchedule>)? onSave;
  final Function(List<FieldSchedule>)? onMultiSelectSave;

  const EmployeeScheduleWidget({
    Key? key,
    this.onMonthChanged,
    this.onSave,
    this.onMultiSelectSave,
    required this.listEmployee,
  }) : super(key: key);

  @override
  State<EmployeeScheduleWidget> createState() => _EmployeeScheduleWidgetState();
}

class _EmployeeScheduleWidgetState extends State<EmployeeScheduleWidget> {
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;

  List<FieldSchedule> editedFields = [];
  List<FieldSchedule> multiSelectedFields = [];
  late ScrollController scrollController;

  changeState(List<FieldSchedule> dataList) {
    Dialogs.scheduleField(
      context: context,
      onConfirm: (val) {
        for (var element in multiSelectedFields) {
          element.status = val;
        }

        print("On mutli select field updated ${multiSelectedFields.length}");

        widget.onMultiSelectSave?.call(dataList);
        multiSelectedFields.clear();
      },
    );
  }

  @override
  void initState() {
    scrollController = ScrollController();

    multiSelectedFields.clear();
    super.initState();
  }

  @override
  void dispose() {
    currentMonth = DateTime.now().month;
    currentYear = DateTime.now().year;
    editedFields.clear();
    scrollController.dispose();
    multiSelectedFields.clear();
    Provider.of<CrossInEmployeeScheduleProvider>(context).clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Scrollbar(
          interactive: true,
          thumbVisibility: true,
          trackVisibility: true,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          thickness: 2,
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(color: Colors.transparent),

                  // decoration: const BoxDecoration(
                  //   color: Colors.transparent,
                  // ),
                  // width: MediaQuery.of(context).size.width -
                  //     (Constants.sideMenuWidth - 20), // Padding 20 (left, right)
                  child: FocusArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 200),
                            MonthSelectorWithDatesWidget(
                              onMonthChanged: (month) {
                                widget.onMonthChanged?.call(month);
                                currentMonth = month;

                                multiSelectedFields.clear();
                                setState(() {});
                              },
                              currentMonth: currentMonth,
                            ),
                          ],
                        ),
                        ...List.generate(widget.listEmployee.length, (index) {
                          final e = widget.listEmployee[index];
                          return _EmployeeScheduleTableWidget(
                            employeeEntity: e,
                            currentMonth: currentMonth,
                            currentYear: currentYear,
                            onFieldEdit: (
                              int day,
                              int month,
                              int year,
                              int status,
                              String employee,
                            ) {
                              final dateTime = DateTime(year, month, day);
                              final entity =
                                  FieldSchedule(dateTime, employee, status);

                              editedFields.add(entity);
                            },
                            onHoverDrag: (field) {
                              print("Drag field ${field.dateTime}");

                              if (multiSelectedFields.contains(field) ==
                                  false) {
                                // multiSelectedFields.remove(field);
                                multiSelectedFields.add(field);
                                print("Fild field $field");
                                setState(() {});
                              }
                            },
                            listSelectedSchedule: multiSelectedFields,
                            rowIndex: index,
                          );
                        }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                widget.onSave?.call(editedFields);
                editedFields.clear();
              },
              child: Text("save".tr(), style: const TextStyle(
                  color: Colors.white
              ),),
            ),
            const SizedBox(width: 10),
            if (multiSelectedFields.length >= 2)
              ElevatedButton(
                onPressed: () {
                  changeState(multiSelectedFields);
                },
                child: Text("selectStatusForSelected".tr()),
              ),
            const SizedBox(width: 10),
            if (multiSelectedFields.length >= 2)
              ElevatedButton(
                onPressed: () {
                  multiSelectedFields.clear();
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("clearSelected".tr(), style: const TextStyle(
                  color: Colors.white
                ),),
              ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _EmployeeScheduleTableWidget extends StatefulWidget {
  final EmployeeEntity employeeEntity;
  final int currentMonth;
  final int rowIndex;
  final int currentYear;
  final Function(FieldSchedule) onHoverDrag;
  final List<FieldSchedule> listSelectedSchedule;
  final Function(int day, int month, int year, int status, String employee)
      onFieldEdit;

  const _EmployeeScheduleTableWidget({
    Key? key,
    required this.employeeEntity,
    required this.rowIndex,
    required this.currentMonth,
    required this.currentYear,
    required this.onFieldEdit,
    required this.onHoverDrag,
    required this.listSelectedSchedule,
  }) : super(key: key);

  @override
  State<_EmployeeScheduleTableWidget> createState() =>
      _EmployeeScheduleTableWidgetState();
}

class _EmployeeScheduleTableWidgetState
    extends State<_EmployeeScheduleTableWidget> {
  Offset? startDragPosition;

  @override
  void initState() {
    startDragPosition = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 35,
          width: 200,
          child: _card(),
        ),
        // Text(widget.listSelectedSchedule.length.toString()),
        ...List.generate(
          StringHelper.getDaysByMonthIndex(month: widget.currentMonth),
          (index) {
            final day = index + 1;
            final year = DateTime.now().year;
            final dateTimeNow = DateTime(year, widget.currentMonth, day);

            final EmployeeScheduleEntity? entity =
                widget.employeeEntity.schedule.firstWhereOrNull((element) {
              final startDateParsing = DateTime.parse(element.date);

              final startDate = DateTime(
                startDateParsing.year,
                startDateParsing.month,
                startDateParsing.day,
              );

              return startDate.difference(dateTimeNow).inDays == 0 &&
                  startDate.month == widget.currentMonth;
              // return startDate.month == startDateParsing.month;
            });

            final startDateParsing = entity == null
                ? null
                : DateTime(
                    DateTime.parse(entity.date).year,
                    DateTime.parse(entity.date).month,
                    DateTime.parse(entity.date).day);

            final fieldSchedule = FieldSchedule(startDateParsing,
                widget.employeeEntity.id, entity?.status ?? 0);

            return RegionDetector(
              onFocused: () {
                if (fieldSchedule.dateTime != null) {
                  if (fieldSchedule.dateTime!.isBefore(dateTimeNow)) return;
                  print(
                      "fieldSchedule datetime  ${fieldSchedule.dateTime} is after ${dateTimeNow}");
                  widget.onHoverDrag.call(fieldSchedule);
                }
              },
              child: _EmployeeScheduleFieldWidget(
                key: Key((day + widget.currentMonth + year).toString()),
                onFieldEdit: widget.onFieldEdit,
                fieldSchedule: fieldSchedule,
                row: widget.rowIndex,
                onHoverDrag: widget.onHoverDrag,
                currentMonth: widget.currentMonth,
                isFieldSElected:
                    widget.listSelectedSchedule.contains(fieldSchedule),
                dateTime: DateTime(year, widget.currentMonth, day),
              ),
            );
          },
        ),
      ],
    );
  }

  _card() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
                image: DecorationImage(
                    image: NetworkImage(widget.employeeEntity.avatar),
                    fit: BoxFit.cover)),
            width: 30,
            height: 30,
            clipBehavior: Clip.antiAlias,
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.employeeEntity.firstName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              Text(
                "+${widget.employeeEntity.phoneNumber}",
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 9,
                ),
              )
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class _EmployeeScheduleFieldWidget extends StatefulWidget {
  final FieldSchedule fieldSchedule;
  final int currentMonth;
  final int row;
  final DateTime dateTime;
  final Function(FieldSchedule) onHoverDrag;
  final bool isFieldSElected;
  final Function(int day, int month, int year, int status, String employee)
      onFieldEdit;

  const _EmployeeScheduleFieldWidget({
    Key? key,
    required this.currentMonth,
    required this.row,
    required this.dateTime,
    required this.onFieldEdit,
    required this.fieldSchedule,
    required this.isFieldSElected,
    required this.onHoverDrag,
  }) : super(key: key);

  @override
  State<_EmployeeScheduleFieldWidget> createState() =>
      _EmployeeScheduleFieldWidgetState();
}

class _EmployeeScheduleFieldWidgetState
    extends State<_EmployeeScheduleFieldWidget> {
  int status = 0;
  bool isDragging = false;
  final blueWithOpacity= Colors.blue.withOpacity(0.4);

  @override
  void initState() {
    status = widget.fieldSchedule.status;

    super.initState();
  }

  changeState() {
    if (widget.fieldSchedule.dateTime != null) {
      final dt = DateTime.now();
      if (widget.fieldSchedule.dateTime == DateTime(dt.year, dt.month, dt.day)) {
        return;
      }
      Dialogs.scheduleField(
        context: context,
        onConfirm: (val) {
          setState(() {
            status = val;
          });

          widget.onFieldEdit.call(
            widget.fieldSchedule.dateTime!.day,
            widget.fieldSchedule.dateTime!.month,
            widget.fieldSchedule.dateTime!.year,
            status,
            widget.fieldSchedule.employeeId,
          );
        },
        day: widget.fieldSchedule.dateTime!.day,
        month: widget.fieldSchedule.dateTime!.month,
        year: widget.fieldSchedule.dateTime!.year,
      );
    }
  }

  onHover(bool hover ) {
    if(hover) {
      Provider.of<CrossInEmployeeScheduleProvider>(context, listen: false)
        .enableCross(hoveredRow: widget.row, hoveredDateTime: widget.dateTime);
    }else {
      Provider.of<CrossInEmployeeScheduleProvider>(context, listen: false)
.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hoverProvider = context.watch<CrossInEmployeeScheduleProvider>();
    final bool hoverCondition =  hoverProvider.dateTime != null &&  hoverProvider.row == widget.row && hoverProvider.dateTime!.day == widget.dateTime.day
        && hoverProvider.dateTime!.year == widget.dateTime.year && hoverProvider.dateTime!.month == widget.dateTime.month;
    final bool beforeCondition = hoverProvider.dateTime != null && widget.dateTime.isBefore(hoverProvider.dateTime!) && hoverProvider.row == widget.row;
    final bool topCondition = hoverProvider.dateTime != null && widget.dateTime.day == hoverProvider.dateTime?.day && widget.row <= hoverProvider.row;



    if (widget.fieldSchedule.dateTime == null) {
      return InkWell(
        onTap: () => changeState(),
        onHover: onHover,
        child: Ink(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color:  beforeCondition ?blueWithOpacity : topCondition ?blueWithOpacity :
            hoverCondition ? Colors.blue : widget.isFieldSElected ? Colors.brown.shade200 : Colors.white,
            // color: multiSelectedFields.contains(widget.fieldSchedule)
            //     ? Colors.brown
            //     : Colors.red,
            border: Border.all(width: 1, color: Colors.grey.shade200),
          ),
        ),
      );
    } else {
      if (status == 0) {
        return InkWell(
          onTap: () => changeState(),
          onHover: onHover,
          child: Ink(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color:  beforeCondition ?blueWithOpacity : topCondition ?blueWithOpacity :

              hoverCondition ? Colors.blue :  widget.isFieldSElected
                  ? Colors.brown.shade200
                  : DateTime.now().day == widget.fieldSchedule.dateTime!.day &&
                          widget.currentMonth ==
                              widget.fieldSchedule.dateTime!.month
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.white,
              // color: multiSelectedFields.contains(widget.fieldSchedule)
              //     ? Colors.brown
              //     : Colors.red,
              border: Border.all(width: 1, color: Colors.grey.shade200),
            ),
          ),
        );
      }
    }

    return InkWell(
      onTap: () => changeState(),
      onHover: onHover,

      child: Ink(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color:  beforeCondition ?blueWithOpacity : topCondition ?blueWithOpacity :

          widget.isFieldSElected
              ? Colors.brown.shade300
              : ColorHelper.getColorForScheduleByStatus(status),
          border: Border.all(
            width: 1,
            color: Colors.grey.shade200,
          ),
        ),
        child: Center(
          child: Text(
            StringHelper.getTitleForScheduleByStatus(status),
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "Nunito",
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
