import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/empty_widget.dart';
import 'package:eleven_crm/features/main/presensation/widget/calendar_ruler_widget.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../core/utils/int_helper.dart';
import '../../../../core/utils/time_table_helper.dart';
import '../../../management/domain/entity/not_working_hours_entity.dart';
import '../../domain/entity/order_entity.dart';

// ignore: must_be_immutable

class TimeTableWidget extends StatefulWidget {
  final List<BarberEntity> listBarbers;
  final List<OrderEntity> listOrders;
  final Function(DateTime from, DateTime to, String employeeId) onTimeConfirm;
  final Function(String employee)? onDeleteEmployeeFromTable;
  final Function(OrderEntity)? onOrderClick;

  const TimeTableWidget({
    Key? key,
    required this.listBarbers,
    required this.onTimeConfirm,
    this.onDeleteEmployeeFromTable,
    this.onOrderClick,
    required this.listOrders,
  }) : super(key: key);

  @override
  State<TimeTableWidget> createState() => _TimeTableWidgetState();
}

class _TimeTableWidgetState extends State<TimeTableWidget> {
  final double rightCellPadding = 5;
  final DateTime from = DateTime(2023, 10, 7, 8);
  final DateTime to = DateTime(2023, 10, 7, 22);

  static final List<BarberEntity> listBarber = [];
  static final List<OrderEntity> listOrders = [];

  @override
  void didUpdateWidget(covariant TimeTableWidget oldWidget) {
    final newListEmployeeLen = widget.listBarbers.length;
    final newListOrdersLen = widget.listOrders.length;
    if (newListEmployeeLen != listBarber.length ||
        newListOrdersLen != listOrders.length) {
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
    listBarber.clear();
    listOrders.clear();

    final List<BarberEntity> employeeListData = widget.listBarbers
        .where((element) => element.inTimeTable == true)
        .toList();

    listBarber.addAll(employeeListData);
    listOrders.addAll(widget.listOrders);
  }

  @override
  Widget build(BuildContext context) {
    return listBarber.isEmpty
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
                      listBarber.length,
                      (index) {
                        final el = listBarber[index];
                        return Expanded(
                          child: _barberUpperCardWidget(el),
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
                            listBarber.length,
                            (barberIndex) {
                              List<OrderEntity> localOrders = [];

                              final barber = listBarber[barberIndex];

                              localOrders = widget.listOrders.where(
                                (element) {
                                  return barber.id == element.barberId;
                                },
                              ).toList();

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

                                                return FieldCardWidget(
                                                  isFirstSection:
                                                      barberIndex == 0,
                                                  hour: hour,
                                                  barberId: barber.id,
                                                  onPositionChanged: () {
                                                    setState(() {});
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      ...localOrders.map(
                                        (orderEntity) {
                                          return Positioned(
                                            // top: Constants.timeTableItemHeight +Constants.timeTableItemHeight  ,
                                            top: TimeTableHelper
                                                .getTopPositionForOrder(
                                              orderEntity,
                                            ),
                                            child: GestureDetector(
                                              onDoubleTap: () => widget
                                                  .onOrderClick
                                                  ?.call(orderEntity),
                                              child: Draggable<OrderEntity>(
                                                data: orderEntity,
                                                childWhenDragging:
                                                    OrderCardWidget(
                                                  order: orderEntity,
                                                  isDragging: true,
                                                ),
                                                feedback: Opacity(
                                                  opacity: 0.6,
                                                  child: Material(
                                                    child: OrderCardWidget(
                                                      order: orderEntity,
                                                      isDragging: false,
                                                    ),
                                                  ),
                                                ),
                                                child: OrderCardWidget(
                                                  order: orderEntity,
                                                  isDragging: false,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      ...barber.notWorkingHours.map(
                                        (notWorkingHoursEntity) {
                                          return Positioned(
                                            top: TimeTableHelper
                                                .getTopPositionForNotWorkingHours(
                                              notWorkingHoursEntity,
                                            ),
                                            child: NotWorkingHoursCard(
                                              notWorkingHoursEntity:
                                                  notWorkingHoursEntity,
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

  _barberUpperCardWidget(BarberEntity entity) {
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
                  listBarber.remove(entity);
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

class NotWorkingHoursCard extends StatefulWidget {
  final NotWorkingHoursEntity notWorkingHoursEntity;
  const NotWorkingHoursCard({Key? key, required this.notWorkingHoursEntity})
      : super(key: key);

  @override
  State<NotWorkingHoursCard> createState() => _NotWorkingHoursCardState();
}

class _NotWorkingHoursCardState extends State<NotWorkingHoursCard> {
  // double _getCardHeight() {
  //   final from = widget.notWorkingHoursEntity.dateFrom;
  //   final to = widget.notWorkingHoursEntity.dateTo;
  //   if (from.hour == to.hour) {
  //     return (from.minute + to.minute).toDouble();
  //   }
  //
  //   return Constants.timeTableItemHeight + (from.minute) - to.minute;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: TimeTableHelper.getCardHeight(
        widget.notWorkingHoursEntity.dateFrom,
        widget.notWorkingHoursEntity.dateTo,
      ),
      color: Colors.brown.withOpacity(0.5),
      child: const SizedBox.expand(),
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
  // double _getCardHeight() {
  //   final dateFrom = widget.order.orderStart;
  //   final dateTo = widget.order.orderEnd;
  //
  //     print("order: ${widget.order.id}, order Start $dateFrom order end $dateTo diff ${dateFrom.difference(dateTo).inHours } ");
  //
  //   final differenceInMinutes = dateFrom.difference(dateTo).inMinutes.abs();
  //   print("Diff ${differenceInMinutes}");
  //   if (dateFrom.hour == dateTo.hour) {
  //     return (dateFrom.minute + dateTo.minute).toDouble();
  //   } else if ( differenceInMinutes <= 60) {
  //     return Constants.timeTableItemHeight;
  //   }
  //
  //   return 200;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      width: Constants.timeTableItemWidth,
      // height: _getCardHeight(),
      height: TimeTableHelper.getCardHeight(
          widget.order.orderStart, widget.order.orderEnd),
      color: widget.isDragging
          ? Colors.grey.shade400.withOpacity(0.3)
          : AppColors.timeTableCard,
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
                          "${DateFormat('HH:mm').format(widget.order.orderStart)} / ${DateFormat('HH:mm').format(widget.order.orderEnd)}",
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
                const SizedBox(height: 3),
                ...widget.order.services.map(
                  (e) => Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
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
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}

class FieldCardWidget extends StatefulWidget {
  final int hour;
  final bool isFirstSection;
  final String barberId;
  final Function() onPositionChanged;

  const FieldCardWidget({
    super.key,
    required this.hour,
    required this.isFirstSection,
    required this.onPositionChanged,
    required this.barberId,
  });

  @override
  State<FieldCardWidget> createState() => _FieldCardWidgetState();
}

class _FieldCardWidgetState extends State<FieldCardWidget> {
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
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          4,
          (index) {
            int minute =
                (index) * 15; // 15, 30, 45, 60 (which will be converted to 0)

            if (minute >= 60) {
              minute = 0; // Convert 60 to 0
            }
            return Expanded(
              child: DragTarget<OrderEntity>(
                onAccept: (order) {
                  TimeTableHelper.onAccept(
                    order,
                    widget.hour,
                    minute,
                    widget.barberId,
                    widget.onPositionChanged,
                  );
                },
                // onAccept: (order) {
                //   print(
                //     "Accept field target $order hour ${widget.hour}",
                //   );
                //
                //   final orderFrom = order.orderStart;
                //   final orderTo = order.orderEnd;
                //
                //   order.orderStart = DateTime(
                //     orderFrom.year,
                //     orderFrom.month,
                //     orderFrom.day,
                //     widget.hour,
                //     minute,
                //   );
                //
                //   final newHour = order.orderStart.hour;
                //   final newMinute = order.orderStart.minute;
                //
                //   final oldHour = orderFrom.hour;
                //   final oldMinute = orderFrom.minute;
                //
                //   final int hourDiff = newHour - oldHour;
                //   final int minuteDiff = newMinute - oldMinute;
                //
                //
                //
                //
                //
                //
                //   if (oldHour < newHour) {
                //     // order.orderEnd = DateTime(
                //     //   orderTo.year,
                //     //   orderTo.month,
                //     //   orderTo.day,
                //     //   orderTo.hour + hourDiff,
                //     //   orderTo.minute + minuteDiff,
                //     // );
                //
                //     log("bottom nav $hourDiff $minuteDiff ");
                //   } else {
                //     // order.orderEnd = DateTime(
                //     //   orderTo.year,
                //     //   orderTo.month,
                //     //   orderTo.day,
                //     //   orderTo.hour - hourDiff,
                //     //   orderTo.minute - minuteDiff,
                //     // );
                //     log("top nav $hourDiff $minuteDiff");
                //   }
                //
                //
                //
                //
                //   //
                //   // data.orderEnd = DateTime(
                //   //   orderTo.year,
                //   //   orderTo.month,
                //   //   orderTo.day,
                //   //   data.orderEnd.hour + differenceFromAndTo,
                //   //   orderTo.minute,
                //   // );
                //   order.barberId = widget.barberId;
                //
                //   widget.onPositionChanged.call();
                // },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    decoration: BoxDecoration(
                      color: candidateData.isNotEmpty
                          ? Colors.orange
                          : Colors.white,
                      border: Border.all(
                        width: 0.3,
                        color: Colors.black26,
                      ),
                    ),

                    width: double.infinity,
                    child: widget.isFirstSection
                        ? const SizedBox()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4, top: 2),
                                child: Text(
                                  "${widget.hour}:${minute == 0 ? "00" : minute}",
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                    // child: Text((index +1).toString()),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
