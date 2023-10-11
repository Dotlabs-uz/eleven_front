import 'package:eleven_crm/features/main/presensation/widget/calendar_ruler_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/int_helper.dart';
import '../../../management/domain/entity/employee_entity.dart';

class Order {
  final String title;
  final int price;
  final DateTime from;
  final DateTime to;
  final String employeeId;

  Order(this.title, this.from, this.to, this.price, this.employeeId);
}

class CalendarMainVersionTwoWidget extends StatefulWidget {
  final List<EmployeeEntity> listEmployee;

  const CalendarMainVersionTwoWidget({Key? key, required this.listEmployee})
      : super(key: key);

  @override
  State<CalendarMainVersionTwoWidget> createState() =>
      _CalendarMainVersionTwoWidgetState();
}

class _CalendarMainVersionTwoWidgetState
    extends State<CalendarMainVersionTwoWidget> {
  final double rightCellPadding = 5;
  final DateTime from = DateTime(2023, 10, 7, 8);
  final DateTime to = DateTime(2023, 10, 7, 22);

  @override
  void initState() {
    // from = DateTime(2023, 10, 7, Constants.startWork.toInt());
    // to = DateTime(2023, 10, 7, Constants.endWork.toInt());
    super.initState();
  }

  final List<Order> orders = [
    Order(
      "title",
      DateTime(2023, 10, 7, 8),
      DateTime(2023, 10, 7, 8, 30),
      30,
      "2",
    ),
    Order(
      "title",
      DateTime(2023, 10, 7, 12),
      DateTime(2023, 10, 7, 13, 30),
      30,
      "3",
    ),
    Order(
      "title",
      DateTime(2023, 10, 7, 20, 30),
      DateTime(2023, 10, 7, 21, 0),
      30,
      "3",
    ),
    Order(
      "title",
      DateTime(2023, 10, 7, 20, 15),
      DateTime(2023, 10, 7, 21),
      30,
      "4",
    ),
    Order(
      "title",
      DateTime(2023, 10, 7, 10, 0),
      DateTime(2023, 10, 7, 11, 5),
      30,
      "1",
    ),
  ];

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
            padding: EdgeInsets.zero,
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
                    ...List.generate(
                      widget.listEmployee.length,
                      (index) {
                        List<Order> localOrders = [];

                        final employee = widget.listEmployee[index];

                        localOrders = orders
                            .where(
                                (element) => employee.id == element.employeeId)
                            .toList();

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    ...List.generate(
                                      IntHelper.getCountOfCardByWorkingHours(
                                          from, to),
                                      (index) {
                                        final hour = from.hour + index;

                                        return SizedBox(
                                          width: Constants.timeTableItemWidth,
                                          child: FieldCardWidget(
                                            hour: hour,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                ...localOrders.map(
                                  (e) {
                                    return Positioned(
                                      // top: Constants.timeTableItemHeight +Constants.timeTableItemHeight  ,
                                      top: _getTopPosition(e),
                                      child: Draggable<int>(
                                        feedback: Container(
                                          width: Constants.timeTableItemWidth,
                                          height: Constants
                                                  .timeTableItemHeight +
                                              (e.to.minute *
                                                  Constants
                                                      .onTimetableFieldItemRound),
                                          color: Colors.pink,
                                        ),
                                        child: Container(
                                          width: Constants.timeTableItemWidth,
                                          height: Constants
                                                  .timeTableItemHeight +
                                              (e.to.minute *
                                                  Constants
                                                      .onTimetableFieldItemRound),
                                          color: Colors.red,
                                          child: Center(
                                            child: Text(
                                              "${e.title} ${e.from.hour}:${e.from.minute} / ${e.to.hour}:${e.to.minute}",
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _getTopPosition(Order order) {
    if (order.from.hour == Constants.startWork) {
      // return Constants.timeTableItemHeight;
      return 0;
    }

    double top = Constants.startWork;



    top -= order.from.hour;

    final formatted = top / -1;

    double height = 0;

    // if((order.to.hour == order.from.hour && order.to.day == order.from.day) == false) {
      for (var i = 0; i < formatted; i++) {
        height += Constants.timeTableItemHeight;
      }
    // }


    height += order.from.minute;

    return height;
  }

  _employeeCardWidget(EmployeeEntity entity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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

class FieldCardWidget extends StatefulWidget {
  final int hour;

  const FieldCardWidget({
    super.key,
    required this.hour,
  });

  @override
  State<FieldCardWidget> createState() => _FieldCardWidgetState();
}

class _FieldCardWidgetState extends State<FieldCardWidget> {
  late int minute;
  @override
  void initState() {
    minute = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: Constants.timeTableItemHeight),
      decoration: BoxDecoration(border: Border.all(width: 1)),
      child: Column(
        children: List.generate(
          12,
          (index) {
            minute += 5;

            if (minute >= 65) {
              minute = 0; // Обнуляем минуты, когда достигнут 60
            }
            return Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(
                    width: 0.3,
                    color: Colors.black26,
                  ),
                ),

                width: double.infinity,
                // child: Center(child: Text("${widget.hour}:${minute}")),
                // child: Text((index +1).toString()),
              ),
            );
          },
        ),
      ),
    );
  }
}
