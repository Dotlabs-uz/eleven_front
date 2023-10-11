import 'package:eleven_crm/features/main/presensation/widget/calendar_ruler_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/int_helper.dart';
import '../../../management/domain/entity/employee_entity.dart';

class CalendarMainWidget extends StatefulWidget {
  final List<EmployeeEntity> listEmployee;
  const CalendarMainWidget({Key? key, required this.listEmployee})
      : super(key: key);

  @override
  State<CalendarMainWidget> createState() => _CalendarMainWidgetState();
}

class _CalendarMainWidgetState extends State<CalendarMainWidget> {
  final double rightCellPadding = 5;
  final DateTime from = DateTime(2023, 10, 7, 8);
  final DateTime to = DateTime(2023, 10, 7, 22);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.orange,
          child: Row(
            children: [
              SizedBox(
                width: Constants.rulerWidth,
              ),
              Container(width: 10),
              ...List.generate(
                widget.listEmployee.length,
                (index) {
                  final el = widget.listEmployee[index];
                  return Expanded(
                    child: _employeeCardWidget(el),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CalendarRulerWidget(
                      timeFrom: from,
                      timeTo: to,
                    ),
                    ...List.generate(widget.listEmployee.length, (index) {
                      final el = widget.listEmployee[index];

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Column(
                            children: [
                              // SizedBox(child: ProgressCard(percent: 0),width: Constants.timeTableItemWidth),
                              ...List.generate(
                                IntHelper.getCountOfCardByWorkingHours(
                                    from, to),
                                (index) {
                                  return SizedBox(
                                    width: Constants.timeTableItemWidth,
                                    child: ProgressCard(
                                      percent: 30,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );

  }
  _employeeCardWidget(EmployeeEntity entity) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text("${entity.firstName} ${entity.lastName}"),
        ],
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  final double percent;

  const ProgressCard({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: Constants.timeTableItemHeight),
      decoration: BoxDecoration(border: Border.all(width: 2)),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300], // Цвет фона
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: _getHeight(percent),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getHeight(double minute) {
 if (minute == 0) {
      return 0;
    } else {
      return minute * 1.6 ;
    }
  }
}
