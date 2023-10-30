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
  final DateTime dateTime;
  final String employeeId;
  final int status;

  FieldSchedule(this.dateTime, this.employeeId, this.status);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['date'] = dateTime.toIso8601String();
    data['employee'] = employeeId;
    data['status'] = status;
    return data;
  }
}

class SelectedFieldsProvider with ChangeNotifier {
  final List<FieldSchedule> _selectedFields = [];

  List<FieldSchedule> get selectedFields => _selectedFields;

  void toggleSelectedField(FieldSchedule field) {
    if (_selectedFields.contains(field)) {
      _selectedFields.remove(field);
    } else {
      _selectedFields.add(field);
    }
    notifyListeners();
  }

  void clearSelectedFields() {
    _selectedFields.clear();
    notifyListeners();
  }
}

class EmployeeScheduleWidget extends StatefulWidget {
  final Function(int)? onMonthChanged;
  final List<EmployeeEntity> listEmployee;
  final Function(List<FieldSchedule>)? onSave;
  final Function(FieldSchedule) onMultiSelect;
  const EmployeeScheduleWidget({
    Key? key,
    this.onMonthChanged,
    this.onSave,
    required this.listEmployee,
    required this.onMultiSelect,
  }) : super(key: key);

  @override
  State<EmployeeScheduleWidget> createState() => _EmployeeScheduleWidgetState();
}

class _EmployeeScheduleWidgetState extends State<EmployeeScheduleWidget> {
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;

  List<FieldSchedule> submittedFields = [];

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
                onMonthChanged: (val) => widget.onMonthChanged?.call(val),
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

                submittedFields.add(entity);
              },
              selectedFields: submittedFields,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  widget.onSave?.call(submittedFields);
                  submittedFields.clear();
                },
                child: Text("save".tr()),
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
  final List<FieldSchedule> selectedFields;
  final Function(int day, int month, int year, int status, String employee)
      onFieldEdit;

  const _EmployeeScheduleTableWidget({
    Key? key,
    required this.employeeEntity,
    required this.currentMonth,
    required this.selectedFields,
    required this.currentYear,
    required this.onFieldEdit,
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
            final EmployeeScheduleEntity? entity =
                employeeEntity.schedule.firstWhereOrNull((element) {
              final startDateParsing = DateTime.parse(element.date);
              final startDate = DateTime(startDateParsing.year,
                  startDateParsing.month, startDateParsing.day);
              final targetDate = DateTime(year, currentMonth, day);
              return startDate.difference(targetDate).inDays == 0;
            });

            final dateTime = DateTime(year, currentMonth, day);
            final fieldSchedule =
                FieldSchedule(dateTime, employeeEntity.id, entity?.status ?? 0);

            return _EmployeeScheduleFieldWidget(
              day: day,
              month: currentMonth,
              year: year,
              selectedFields: selectedFields,
              onFieldChange: onFieldEdit,
              employeeId: employeeEntity.id,
              fieldStatus: entity?.status ?? 0,
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
  final int fieldStatus;
  final int day;
  final int year;
  final int month;
  final String employeeId;
  final List<FieldSchedule> selectedFields;
  final Function(int day, int month, int year, int status, String employee)
      onFieldChange;

  const _EmployeeScheduleFieldWidget({
    Key? key,
    required this.fieldStatus,
    required this.day,
    required this.year,
    required this.month,
    required this.onFieldChange,
    required this.selectedFields,
    required this.employeeId,
  }) : super(key: key);

  @override
  State<_EmployeeScheduleFieldWidget> createState() =>
      _EmployeeScheduleFieldWidgetState();
}

class _EmployeeScheduleFieldWidgetState
    extends State<_EmployeeScheduleFieldWidget> {
  int status = 0;

  @override
  void initState() {
    status = widget.fieldStatus;

    super.initState();
  }

  changeState() {
    Dialogs.scheduleField(
      context: context,
      onConfirm: (val) {
        setState(() {
          status = val;
        });

        widget.onFieldChange.call(
          widget.day,
          widget.month,
          widget.year,
          status,
          widget.employeeId,
        );
      },
      day: widget.day,
      month: widget.month,
      year: widget.year,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (status == 0) {
      return InkWell(
        onTap: () => changeState(),
        child: Ink(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: widget.selectedFields.contains(
              FieldSchedule(DateTime(widget.year, widget.day, widget.month),
                  widget.employeeId, status),
            )
                ? Colors.red
                : DateTime.now().day == widget.day
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.white,
            border: Border.all(width: 1, color: Colors.grey.shade200),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => changeState(),
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
