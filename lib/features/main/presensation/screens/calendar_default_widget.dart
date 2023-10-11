import 'package:eleven_crm/features/main/presensation/widget/calendar_ruler_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/int_helper.dart';
import '../../../management/domain/entity/employee_entity.dart';

class CalendarDefaultWidget extends StatefulWidget {
  final List<EmployeeEntity> listEmployee;
  const CalendarDefaultWidget({Key? key, required this.listEmployee})
      : super(key: key);

  @override
  State<CalendarDefaultWidget> createState() => _CalendarDefaultWidgetState();
}

class _CalendarDefaultWidgetState extends State<CalendarDefaultWidget> {
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
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.listEmployee.length,
      itemBuilder: (context, index) {
        final data = widget.listEmployee[index];
        return _timetableWidget(data);
      },
    );
  }

  // _timetableWidget(EmployeeEntity entity) {
  //   return         Container(
  //     constraints: BoxConstraints(maxWidth: 200),
  //
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             SizedBox(width: leftSpace),
  //             ...widget.listEmployee.map(
  //                   (e) => Container(
  //                 color: Colors.red,
  //                 width: 400,
  //                 margin: EdgeInsets.only(right: rightCellPadding),
  //                 child: _employeeCardWidget(e),
  //               ),
  //             ),
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             SizedBox(width: leftSpace),
  //             ...widget.listEmployee.map(
  //                   (e) => Container(
  //                 width: 400,
  //                 margin: EdgeInsets.only(right: rightCellPadding),
  //                 child: const Placeholder(),
  //               ),
  //             )
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  _timetableWidget(EmployeeEntity entity) {
    return Container(
      constraints: BoxConstraints(maxWidth: Constants.timeTableItemWidth),
      child: Column(
        children: [
          _employeeCardWidget(entity),
          const ProgressCard(
            percent: 50,
          ),
          // Container(
          //   margin: EdgeInsets.only(right: rightCellPadding),
          //   child: const Placeholder(),
          // ),
        ],
      ),
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
