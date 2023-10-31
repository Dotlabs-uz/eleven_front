import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/utils/dialogs.dart';
import 'package:eleven_crm/features/management/domain/entity/employee_schedule_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/color_helper.dart';
import '../../../../core/utils/string_helper.dart';
import '../../domain/entity/employee_entity.dart';
import 'month_selector_with_dates_widget.dart';

import 'package:flutter/material.dart';

class FieldSchedule {
  DateTime? dateTime;
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

  changeState(List<FieldSchedule> dataList) {
    Dialogs.scheduleField(
      context: context,
      onConfirm: (val) {
        for (var element in multiSelectedFields) {
          element.status = val;
        }

        widget.onMultiSelectSave?.call(dataList);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
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
          ...widget.listEmployee.map(
            (e) => _EmployeeScheduleTableWidget(
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
                final entity = FieldSchedule(dateTime, employee, status);

                editedFields.add(entity);
              },
              onTap: (field) {
                if (multiSelectedFields.contains(field)) {
                  multiSelectedFields.remove(field);
                } else {
                  multiSelectedFields.add(field);
                }
              },
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
                child: Text("save".tr()),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  changeState(multiSelectedFields);
                },
                child: Text("selectStatusForSelected".tr()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmployeeScheduleTableWidget extends StatelessWidget {
  final EmployeeEntity employeeEntity;
  final int currentMonth;
  final int currentYear;
  final Function(FieldSchedule) onTap;
  final Function(int day, int month, int year, int status, String employee)
      onFieldEdit;

  const _EmployeeScheduleTableWidget({
    Key? key,
    required this.employeeEntity,
    required this.currentMonth,
    required this.currentYear,
    required this.onFieldEdit,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 35,
          width: 200,
          child: _card(),
        ),
        ...List.generate(
          StringHelper.getDaysByMonthIndex(month: currentMonth),
          (index) {
            final day = index + 1;
            final year = DateTime.now().year;
            final dateTimeNow = DateTime(year, currentMonth, day);

            final EmployeeScheduleEntity? entity =
                employeeEntity.schedule.firstWhereOrNull((element) {
              final startDateParsing = DateTime.parse(element.date);

              final startDate = DateTime(
                startDateParsing.year,
                startDateParsing.month,
                startDateParsing.day,
              );

              return startDate.difference(dateTimeNow).inDays == 0 &&
                  startDate.month == currentMonth;
              // return startDate.month == startDateParsing.month;
            });

            final startDateParsing = entity == null
                ? null
                : DateTime(
                    DateTime.parse(entity.date).year,
                    DateTime.parse(entity.date).month,
                    DateTime.parse(entity.date).day);

            final fieldSchedule = FieldSchedule(
                startDateParsing, employeeEntity.id, entity?.status ?? 0);

            return _EmployeeScheduleFieldWidget(
              onFieldEdit: onFieldEdit,
              fieldSchedule: fieldSchedule,
              onTap: onTap,
              currentMonth: currentMonth,
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employeeEntity.firstName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              Text(
                employeeEntity.role,
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 11,
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
  final Function(FieldSchedule) onTap;
  final Function(int day, int month, int year, int status, String employee)
      onFieldEdit;

  const _EmployeeScheduleFieldWidget({
    Key? key,
    required this.currentMonth,
    required this.onFieldEdit,
    required this.fieldSchedule,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_EmployeeScheduleFieldWidget> createState() =>
      _EmployeeScheduleFieldWidgetState();
}

class _EmployeeScheduleFieldWidgetState
    extends State<_EmployeeScheduleFieldWidget> {
  int status = 0;
  bool isDragging = false;

  static List<FieldSchedule> multiSelectedFields = [];

  @override
  void initState() {
    status = widget.fieldSchedule.status;
    super.initState();
  }

  changeState() {
    if (widget.fieldSchedule.dateTime != null) {
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

  @override
  Widget build(BuildContext context) {
    if (widget.fieldSchedule.dateTime == null) {
      return InkWell(
        onLongPress: () => changeState(),
        onTap: () {
          if (multiSelectedFields.contains(widget.fieldSchedule)) {
            multiSelectedFields.remove(widget.fieldSchedule);
          } else {
            multiSelectedFields.add(widget.fieldSchedule);
          }

          print(
            "Multi selected field local inside field ${multiSelectedFields.length}",
          );
          widget.onTap.call(widget.fieldSchedule);
          setState(() {});
        },
        child: Ink(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: multiSelectedFields.contains(widget.fieldSchedule)
                ? Colors.brown.shade200
                : Colors.white,
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
          onLongPress: () => changeState(),
          onTap: () {
            if (multiSelectedFields.contains(widget.fieldSchedule)) {
              multiSelectedFields.remove(widget.fieldSchedule);
            } else {
              multiSelectedFields.add(widget.fieldSchedule);
            }

            print(
              "Multi selected field local inside field ${multiSelectedFields.length}",
            );
            widget.onTap.call(widget.fieldSchedule);
            setState(() {});
          },
          child: Ink(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: multiSelectedFields.contains(widget.fieldSchedule)
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
      onTap: () => widget.onTap.call(widget.fieldSchedule),
      onLongPress: () => changeState(),
      child: Ink(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: ColorHelper.getColorForScheduleByStatus(status),
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
