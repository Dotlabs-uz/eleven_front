import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/features/main/presensation/widget/calendar_ruler_widget.dart';
import 'package:eleven_crm/features/products/domain/entity/service_product_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/int_helper.dart';
import '../../../management/domain/entity/employee_entity.dart';
import '../../domain/entity/order_entity.dart';

// ignore: must_be_immutable

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

  final List<OrderEntity> orders = [
    OrderEntity(
      orderStart: DateTime(2023, 10, 7, 9),
      orderEnd: DateTime(2023, 10, 7, 9, 30),
      price: 30,
      barberId: "2",
      services: const [
        ServiceProductEntity(
          id: "id",
          name: "name",
          price: "30",
          duration: "30",
          categoryId: "categoryId",
          sex: "sex",
        ),
      ],
      discount: 2,
      discountPercent: 2,
      clientId: "333",
      paymentType: OrderPayment.cash,
    ),
    OrderEntity(
      discount: 2,
      discountPercent: 2,
      clientId: "333",
      paymentType: OrderPayment.cash,
      orderStart: DateTime(2023, 10, 7, 12),
      orderEnd: DateTime(2023, 10, 7, 13, 30),
      price: 30,
      barberId: "3",
      services: [],
    ),
    OrderEntity(
      discount: 2,
      discountPercent: 2,
      clientId: "333",
      paymentType: OrderPayment.cash,
      orderStart: DateTime(2023, 10, 7, 20, 30),
      orderEnd: DateTime(2023, 10, 7, 21, 0),
      price: 30,
      barberId: "3",
      services: [],
    ),
    OrderEntity(
      discount: 2,
      discountPercent: 2,
      clientId: "333",
      paymentType: OrderPayment.cash,
      orderStart: DateTime(2023, 10, 7, 20, 15),
      orderEnd: DateTime(2023, 10, 7, 21, 30),
      price: 30,
      barberId: "4",
      services: [],
    ),
    OrderEntity(
      discount: 2,
      discountPercent: 2,
      clientId: "333",
      paymentType: OrderPayment.cash,
      orderStart: DateTime(2023, 10, 7, 10, 0),
      orderEnd: DateTime(2023, 10, 7, 11, 5),
      price: 30,
      barberId: "1",
      services: [],
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
                        List<OrderEntity> localOrders = [];

                        final employee = widget.listEmployee[index];

                        localOrders = orders
                            .where((element) => employee.id == element.barberId)
                            .toList();

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey.shade400),
                                      top: BorderSide(
                                          width: 1,
                                          color: Colors.grey.shade400),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      ...List.generate(
                                        IntHelper.getCountOfCardByWorkingHours(
                                            from, to),
                                        (index) {
                                          final hour = from.hour + index;

                                          return DragTarget<OrderEntity>(
                                            builder: (context, candidateData,
                                                rejectedData) {
                                              return FieldCardWidget(
                                                hour: hour,
                                                highlighted:
                                                    candidateData.isNotEmpty,
                                              );
                                            },
                                            onAccept: (data) {
                                              print(
                                                "Accept field target $data hour $hour",
                                              );

                                              final orderFrom = data.orderStart;
                                              final orderTo = data.orderEnd;

                                              data.orderStart = DateTime(
                                                orderFrom.year,
                                                orderFrom.month,
                                                orderFrom.day,
                                                hour,
                                                orderFrom.minute,
                                              );

                                              final int differenceFromAndTo =
                                                  (orderFrom.hour -
                                                          data.orderStart
                                                              .hour) ~/
                                                      -1;

                                              data.orderEnd = DateTime(
                                                orderTo.year,
                                                orderTo.month,
                                                orderTo.day,
                                                data.orderEnd.hour +
                                                    differenceFromAndTo,
                                                orderTo.minute,
                                              );
                                              data.barberId = employee.id;

                                              setState(() {});
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                // DragTarget<Order>(
                                //   builder:
                                //       (context, candidateData, rejectedData) {
                                //     // return Container(
                                //     //   height: Constants.timeTableItemHeight,
                                //     //   color: candidateData.isNotEmpty ? Colors.orange:  Colors.green,
                                //     // );
                                //
                                //     // Order? candidate;
                                //     //
                                //     // if (candidateData.isNotEmpty) {
                                //     //   candidate = candidateData.first;
                                //     // }
                                //
                                //     return Column(
                                //       children: [
                                //         ...List.generate(
                                //           IntHelper
                                //               .getCountOfCardByWorkingHours(
                                //                   from, to),
                                //           (index) {
                                //             final hour = from.hour + index;
                                //
                                //             return FieldCardWidget(
                                //               hour: hour,
                                //               // highlighted: false,
                                //               // highlighted: (candidate !=
                                //               //         null) &&
                                //               //     candidate.from.hour == hour,
                                //               highlighted: candidateData.isNotEmpty,
                                //             );
                                //           },
                                //         ),
                                //       ],
                                //     );
                                //   },
                                //   // onMove: (details) {
                                //   //   print("Details");
                                //   // },
                                //
                                //   onLeave: (data) {
                                //     print("Data leave");
                                //   },
                                //   onAccept: (data) {
                                //     // if(data != null) {
                                //     print("Accept $data");
                                //
                                //     // }
                                //   },
                                // ),
                                ...localOrders.map(
                                  (e) {
                                    return Positioned(
                                      // top: Constants.timeTableItemHeight +Constants.timeTableItemHeight  ,
                                      top: _getTopPosition(e),
                                      child: Draggable<OrderEntity>(
                                        data: e,
                                        childWhenDragging: OrderCardWidget(
                                          order: e,
                                          isDragging: true,
                                        ),
                                        feedback: Opacity(
                                          opacity: 0.6,
                                          child: Material(
                                            child: OrderCardWidget(
                                              order: e,
                                              isDragging: false,
                                            ),
                                          ),
                                        ),
                                        child: OrderCardWidget(
                                          order: e,
                                          isDragging: false,
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



  double _getTopPosition(OrderEntity order) {
    if (order.orderStart.hour == Constants.startWork) {
      // return Constants.timeTableItemHeight;
      return 0;
    }

    double top = Constants.startWork;

    top -= order.orderStart.hour;

    final formatted = top / -1;

    double height = 0;

    // if((order.to.hour == order.from.hour && order.to.day == order.from.day) == false) {
    for (var i = 0; i < formatted; i++) {
      height += Constants.timeTableItemHeight;
    }
    // }

    height += order.orderStart.minute;

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
  }
}

class OrderCardWidget extends StatefulWidget {
  final OrderEntity order;
  final bool isDragging;
  const OrderCardWidget(
      {Key? key, required this.order, required this.isDragging})
      : super(key: key);

  @override
  State<OrderCardWidget> createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget> {

  double _getCardHeight() {

    if(widget.order.orderStart.hour == widget.order.orderEnd.hour) {
      return widget.order.orderEnd.minute * Constants.onTimetableFieldItemRound;
    }

    return Constants.timeTableItemHeight +
        (widget.order.orderEnd.minute * Constants.onTimetableFieldItemRound) -
        widget.order.orderStart.minute;

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.timeTableItemWidth,
      height: _getCardHeight(),
      color: widget.isDragging ? Colors.grey.shade400 : AppColors.timeTableCard,
      child: !widget.isDragging
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColors.timeTableCardAppBar,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          "${DateFormat('hh:mm').format(widget.order.orderStart)} / ${DateFormat('hh:mm').format(widget.order.orderEnd)}",
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ...widget.order.services.map(
                  (e) => Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "${e.name} ${e.price}сум. ${e.duration}м.",
                          style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}

class FieldCardWidget extends StatefulWidget {
  final int hour;
  final bool highlighted;

  const FieldCardWidget({
    super.key,
    required this.hour,
    required this.highlighted,
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
      constraints: BoxConstraints(
        maxHeight: Constants.timeTableItemHeight,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.black26)),
        // border: Border.all(width: 1),
      ),
      child: Column(
        children: List.generate(
          12,
          (index) {
            minute += 5;

            if (minute >= 65) {
              minute = 0;
            }
            return Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.highlighted ? Colors.orange : Colors.white,
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
