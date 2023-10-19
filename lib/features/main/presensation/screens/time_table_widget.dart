import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/empty_widget.dart';
import 'package:eleven_crm/features/main/presensation/widget/calendar_ruler_widget.dart';
import 'package:eleven_crm/features/products/domain/entity/service_product_category_entity.dart';
import 'package:eleven_crm/features/products/domain/entity/service_product_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../core/utils/int_helper.dart';
import '../../../management/domain/entity/employee_entity.dart';
import '../../../management/domain/entity/not_working_hours_entity.dart';
import '../../domain/entity/order_entity.dart';

// ignore: must_be_immutable

class TimeTableWidget extends StatefulWidget {
  final List<EmployeeEntity> listEmployee;
  final Function(DateTime from, DateTime to, String employeeId) onTimeConfirm;
  final Function(String employee)? onDeleteEmployeeFromTable;

  const TimeTableWidget({
    Key? key,
    required this.listEmployee,
    required this.onTimeConfirm,
    this.onDeleteEmployeeFromTable,
  }) : super(key: key);

  @override
  State<TimeTableWidget> createState() => _TimeTableWidgetState();
}

class _TimeTableWidgetState extends State<TimeTableWidget> {
  final double rightCellPadding = 5;
  final DateTime from = DateTime(2023, 10, 7, 8);
  final DateTime to = DateTime(2023, 10, 7, 22);

  static final List<EmployeeEntity> listEmployee = [];

  @override
  void didUpdateWidget(covariant TimeTableWidget oldWidget) {
    final newListLen = widget.listEmployee.length;
    if (newListLen != listEmployee.length) {
      initialize();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() {
    listEmployee.clear();

    final List<EmployeeEntity> employeeListData = widget.listEmployee
        .where((element) => element.inTimeTable == true)
        .toList();

    listEmployee.addAll(employeeListData);
  }

  final List<OrderEntity> orders = [
    OrderEntity(
      orderStart: DateTime(2023, 10, 7, 9, 10),
      orderEnd: DateTime(2023, 10, 7, 9, 30),
      price: 30,
      barberId: "2",
      services: [
        ServiceProductEntity(
          id: "id",
          name: "name",
          price: 30,
          duration: 30,
          category: ServiceProductCategoryEntity.empty(),
          sex: "man",
        ),
      ],
      discount: 2,
      discountPercent: 2,
      clientId: "333",
      paymentType: OrderPayment.cash,
      id: '',
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
      id: '',
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
      id: '',
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
      id: '',
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
      id: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return listEmployee.isEmpty
        ? const EmptyWidget()
        : Column(
            children: [
              Container(
                color: Colors.white,
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
                                  .where((element) =>
                                      employee.id == element.barberId)
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
                                              color: Colors.grey.shade400,
                                            ),
                                            top: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            ...List.generate(
                                              IntHelper
                                                  .getCountOfCardByWorkingHours(
                                                      from, to),
                                              (index) {
                                                final hour = from.hour + index;

                                                return DragTarget<OrderEntity>(
                                                  builder: (context,
                                                      candidateData,
                                                      rejectedData) {
                                                    return FieldCardWidget(
                                                      hour: hour,
                                                      highlighted: candidateData
                                                          .isNotEmpty,
                                                    );
                                                  },
                                                  onAccept: (data) {
                                                    print(
                                                      "Accept field target $data hour $hour",
                                                    );

                                                    final orderFrom =
                                                        data.orderStart;
                                                    final orderTo =
                                                        data.orderEnd;

                                                    data.orderStart = DateTime(
                                                      orderFrom.year,
                                                      orderFrom.month,
                                                      orderFrom.day,
                                                      hour,
                                                      orderFrom.minute,
                                                    );

                                                    final int
                                                        differenceFromAndTo =
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
                                              childWhenDragging:
                                                  OrderCardWidget(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text("${entity.firstName} ${entity.lastName}"),
            ],
          ),
          IconButton(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onPressed: () {
              Dialogs.timeTableEmployeeDialog(
                context: context,
                onTimeConfirm: (timeFrom, timeTo) {
                  widget.onTimeConfirm.call(
                    timeFrom,
                    timeTo,
                    entity.id,
                  );
                },
                onDeleteEmployeeFromTable: () {
                  listEmployee.remove(entity);
                  widget.onDeleteEmployeeFromTable?.call(entity.id);

                  setState(() {});
                },
              );
            },
            icon: const Icon(Icons.more_vert),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _NotWorkingHoursCard extends StatefulWidget {
  final NotWorkingHoursEntity notWorkingHoursEntity;
  const _NotWorkingHoursCard({Key? key, required this.notWorkingHoursEntity})
      : super(key: key);

  @override
  State<_NotWorkingHoursCard> createState() => _NotWorkingHoursCardState();
}

class _NotWorkingHoursCardState extends State<_NotWorkingHoursCard> {
  double _getCardHeight() {
    if (widget.notWorkingHoursEntity.dateFrom.hour ==
        widget.notWorkingHoursEntity.dateTo.hour) {
      return widget.notWorkingHoursEntity.dateTo.minute *
          Constants.onTimetableFieldItem;
    }

    return Constants.timeTableItemHeight +
        (widget.notWorkingHoursEntity.dateTo.minute *
            Constants.onTimetableFieldItem) -
        widget.notWorkingHoursEntity.dateFrom.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: _getCardHeight(),
      color: Colors.brown.withOpacity(0.5),
      child: const SizedBox.shrink(),
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
    if (widget.order.orderStart.hour == widget.order.orderEnd.hour) {
      return widget.order.orderEnd.minute * Constants.onTimetableFieldItemRound;
    }

    return Constants.timeTableItemHeight +
        (widget.order.orderEnd.minute * Constants.onTimetableFieldItemRound) -
        widget.order.orderStart.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width  ,
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
