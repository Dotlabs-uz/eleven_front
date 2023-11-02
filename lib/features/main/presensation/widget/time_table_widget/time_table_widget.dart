import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/components/empty_widget.dart';
import 'package:eleven_crm/features/main/presensation/widget/time_table_widget/time_table_ruler_widget.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/dialogs.dart';
import '../../../../../core/utils/int_helper.dart';
import '../../../../../core/utils/time_table_helper.dart';
import '../../../../management/domain/entity/not_working_hours_entity.dart';
import '../../../domain/entity/order_entity.dart';
import 'field_card_widget.dart';
import 'no_working_hours_card_widget.dart';
import 'order_card_widget.dart';

// ignore: must_be_immutable

class TimeTableWidget extends StatefulWidget {
  final List<BarberEntity> listBarbers;
  final List<OrderEntity> listOrders;
  final Function(DateTime from, DateTime to, String employeeId)
      onNotWorkingHoursCreate;
  final Function(String employee)? onDeleteEmployeeFromTable;
  final Function(OrderEntity)? onOrderClick;
  final Function(int hour, int minute)? onFieldTap;
  final Function(NotWorkingHoursEntity, BarberEntity)? onTapNotWorkingHour;
  final Function(OrderEntity order)? onTopOrderEnd;
  final Function(OrderEntity order)? onBottomOrderEnd;

  const TimeTableWidget({
    Key? key,
    required this.listBarbers,
    required this.onNotWorkingHoursCreate,
    this.onDeleteEmployeeFromTable,
    this.onFieldTap,
    this.onOrderClick,
    this.onTapNotWorkingHour,
    required this.listOrders,
    this.onTopOrderEnd,
    this.onBottomOrderEnd,
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

  _onOrderSize() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return listBarber.isEmpty
        ? const EmptyWidget()
        : Row(
          children: [
            Flexible(
              child: Column(
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
                              TimeTableRulerWidget(
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
                                      padding:
                                          const EdgeInsets.only(top: 24),
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  width: 1,
                                                  color:
                                                      Colors.grey.shade400,
                                                ),
                                                top: BorderSide(
                                                  width: 1,
                                                  color:
                                                      Colors.grey.shade400,
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
                                                    final hour =
                                                        from.hour + index;

                                                    return FieldCardWidget(
                                                      isFirstSection:
                                                          barberIndex == 0,
                                                      hour: hour,
                                                      barberId: barber.id,
                                                      onPositionChanged:
                                                          () {
                                                        setState(() {});
                                                      },
                                                      notWorkingHours: barber
                                                          .notWorkingHours,
                                                      onFieldTap: (hour,
                                                              minute) =>
                                                          widget.onFieldTap
                                                              ?.call(hour,
                                                                  minute),
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
                                                  child:
                                                      Draggable<DragOrder>(
                                                    data: DragOrder(
                                                      isResizing: false,
                                                      orderEntity:
                                                          orderEntity,
                                                    ),
                                                    childWhenDragging:
                                                        OrderCardWidget(
                                                      order: orderEntity,
                                                      isDragging: true,
                                                      onOrderSize:
                                                          _onOrderSize,
                                                    ),
                                                    feedback: Opacity(
                                                      opacity: 0.6,
                                                      child: Material(
                                                        child:
                                                            OrderCardWidget(
                                                          order:
                                                              orderEntity,
                                                          isDragging: true,
                                                          onOrderSize:
                                                              _onOrderSize,
                                                        ),
                                                      ),
                                                    ),
                                                    child: OrderCardWidget(
                                                      order: orderEntity,
                                                      isDragging: false,
                                                      onOrderSize:
                                                          _onOrderSize,
                                                      onBottomOrderEnd: widget
                                                          .onBottomOrderEnd,
                                                      onTopOrderEnd: widget
                                                          .onTopOrderEnd,
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
                                                  onDoubleTap: (entity) =>
                                                      widget
                                                          .onTapNotWorkingHour
                                                          ?.call(entity,
                                                              barber),
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: entity.avatar.isEmpty
                      ? const DecorationImage(
                          image: AssetImage(
                            Assets.tAvatarPlaceHolder,
                          ),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: NetworkImage(
                            entity.avatar,
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
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
                  widget.onNotWorkingHoursCreate.call(
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
