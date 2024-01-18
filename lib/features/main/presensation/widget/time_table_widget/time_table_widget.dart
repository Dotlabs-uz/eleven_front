import 'package:eleven_crm/core/components/empty_widget.dart';
import 'package:eleven_crm/core/components/image_view_widget.dart';
import 'package:eleven_crm/features/main/presensation/cubit/order/not_working_hours/not_working_hours_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/order_filter_cubit.dart';
import 'package:eleven_crm/features/main/presensation/widget/time_table_widget/past_time_card_widget.dart';
import 'package:eleven_crm/features/main/presensation/widget/time_table_widget/time_table_ruler_widget.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_entity.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/dialogs.dart';
import '../../../../../core/utils/int_helper.dart';
import '../../../../../core/utils/time_table_helper.dart';
import '../../../../management/data/model/not_working_hours_model.dart';
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
  final Function(OrderEntity)? onOrderDoubleTap;
  final String orderFilterQuery;
  final Function(OrderEntity)? onOrderDragEnd;
  final Function(int hour, int minute, String barberId)? onFieldTap;
  final Function(NotWorkingHoursEntity, BarberEntity)? onTapNotWorkingHour;
  final Function(OrderEntity order)? onOrderStartResizeEnd;
  final Function(OrderEntity order)? onOrderEndResizeEnd;
  final Function(OrderEntity)? onOrderTap;
  final Function(String employeeId, BarberEntity entity)
      onChangeEmployeeSchedule;

  const TimeTableWidget({
    Key? key,
    required this.listBarbers,
    required this.onChangeEmployeeSchedule,
    required this.onNotWorkingHoursCreate,
    this.onDeleteEmployeeFromTable,
    this.orderFilterQuery = "",
    this.onFieldTap,
    this.onOrderDragEnd,
    this.onOrderDoubleTap,
    this.onOrderTap,
    this.onTapNotWorkingHour,
    required this.listOrders,
    this.onOrderStartResizeEnd,
    this.onOrderEndResizeEnd,
  }) : super(key: key);

  @override
  State<TimeTableWidget> createState() => _TimeTableWidgetState();
}

class _TimeTableWidgetState extends State<TimeTableWidget> {
  final DateTime from = DateTime(2023, 10, 7, Constants.startWork.toInt());
  final DateTime to = DateTime(2023, 10, 7, Constants.endWork.toInt());

  static final List<BarberEntity> listBarber = [];
  static final List<OrderEntity> listOrders = [];
  static List<NotWorkingHoursEntity> listAllNotWorkingHoursForBarber = [];
  static String lastFilteredDate = "";
  final ScrollController scrollController = ScrollController();

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
    listAllNotWorkingHoursForBarber.clear();

    final List<BarberEntity> employeeListData =
        widget.listBarbers.where((element) {
      return element.inTimeTable == true;
    }).toList();

    initLastFilterDate();

    listBarber.addAll(employeeListData);
    listOrders.addAll(widget.listOrders);
  }

  _onOrderSize() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    listBarber.clear();
    listOrders.clear();
    listAllNotWorkingHoursForBarber.clear();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    listBarber.clear();
    listOrders.clear();
    listAllNotWorkingHoursForBarber.clear();

    super.dispose();
  }

  initLastFilterDate() async {
    final box = await Hive.openBox("orderFilter");
    final response = await box.get("filter");
    lastFilteredDate = DateTime.now().toIso8601String();
    if (response == null || response.toString().isEmpty) {
      lastFilteredDate = DateTime.now().toIso8601String();
      return;
    }

    lastFilteredDate = response;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: listBarber.isEmpty
          ? const EmptyWidget()
          : MultiBlocListener(
              listeners: [
                BlocListener<OrderFilterCubit, OrderFilterHelper>(
                  listener: (context, state) {
                    initLastFilterDate();
                  },
                ),
                BlocListener<NotWorkingHoursCubit, NotWorkingHoursState>(
                  listener: (context, state) {
                    if (state is NotWorkingHoursSaved) {
                      listAllNotWorkingHoursForBarber.add(NotWorkingHoursModel(
                          dateFrom: state.dateFrom, dateTo: state.dateTo));

                      if (lastFilteredDate.isEmpty) {
                        BlocProvider.of<OrderFilterCubit>(context)
                            .setFilter(query: DateTime.now().toIso8601String());
                      }
                      // else {
                      //   BlocProvider.of<OrderFilterCubit>(context).setFilter(query: lastFilteredDate);
                      // }
                    }
                  },
                ),
              ],
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Scrollbar(
                    interactive: true,
                    thumbVisibility: true,
                    trackVisibility: true,
                    controller: scrollController,
                    child: ListView(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: (listBarber.length *
                                  Constants.sizeOfTimeTableColumn) -
                              (Constants.notSelectedBarbersWidth -
                                  Constants.sideMenuWidth) -
                              40 -
                              Constants.rulerWidth, // 40 padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                        return SizedBox(
                                          width:
                                              Constants.sizeOfTimeTableColumn,
                                          child: _barberUpperCardWidget(el),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: ListView(
                                physics: const ClampingScrollPhysics(),
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TimeTableRulerWidget(
                                        timeFrom: from,
                                        timeTo: to,
                                      ),
                                      ...List.generate(
                                        listBarber.length,
                                        (barberIndex) {
                                          List<OrderEntity> localOrders = [];

                                          final barber =
                                              listBarber[barberIndex];

                                          localOrders = widget.listOrders.where(
                                            (element) {
                                              final DateTime? lastFilterDt =
                                                  DateTime.tryParse(
                                                      lastFilteredDate);
                                              final DateTime elementDt =
                                                  element.orderStart;

                                              return barber.id ==
                                                      element.barberId &&
                                                  lastFilterDt != null &&
                                                  (elementDt.day ==
                                                          lastFilterDt.day &&
                                                      elementDt.month ==
                                                          lastFilterDt.month &&
                                                      elementDt.year ==
                                                          lastFilterDt.year);
                                            },
                                          ).toList();

                                          listAllNotWorkingHoursForBarber =
                                              barber.notWorkingHours;

                                          return SizedBox(
                                            width:
                                                Constants.sizeOfTimeTableColumn,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 24),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          width: 1,
                                                          color: Colors
                                                              .grey.shade400,
                                                        ),
                                                        top: BorderSide(
                                                          width: 1,
                                                          color: Colors
                                                              .grey.shade400,
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
                                                                from.hour +
                                                                    index;

                                                            return FieldCardWidget(
                                                              isFirstSection:
                                                                  barberIndex ==
                                                                      0,
                                                              hour: hour,
                                                              barberId:
                                                                  barber.id,
                                                              onDragEnded:
                                                                  (localOrder,
                                                                      confirm) {
                                                                setState(() {});

                                                                if (confirm) {
                                                                  widget
                                                                      .onOrderDragEnd
                                                                      ?.call(
                                                                          localOrder);
                                                                }
                                                              },
                                                              notWorkingHours:
                                                                  barber
                                                                      .notWorkingHours,
                                                              onFieldTap: (hour,
                                                                      minute) =>
                                                                  widget
                                                                      .onFieldTap
                                                                      ?.call(
                                                                          hour,
                                                                          minute,
                                                                          barber
                                                                              .id),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (localOrders.isNotEmpty)
                                                    ...localOrders.map(
                                                      (orderEntity) {
                                                        return Positioned(
                                                          // top: Constants.timeTableItemHeight +Constants.timeTableItemHeight  ,
                                                          top: TimeTableHelper
                                                              .getTopPositionForOrder(
                                                            orderEntity,
                                                          ),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () => widget
                                                                .onOrderTap
                                                                ?.call(
                                                                    orderEntity),
                                                            onDoubleTap: () => widget
                                                                .onOrderDoubleTap
                                                                ?.call(
                                                                    orderEntity),
                                                            child: Draggable<
                                                                DragOrder>(
                                                              data: DragOrder(
                                                                isResizing:
                                                                    false,
                                                                orderEntity:
                                                                    orderEntity,
                                                              ),
                                                              childWhenDragging:
                                                                  OrderCardWidget(
                                                                order:
                                                                    orderEntity,
                                                                isDragging:
                                                                    true,
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
                                                                    isDragging:
                                                                        true,
                                                                    onOrderSize:
                                                                        _onOrderSize,
                                                                  ),
                                                                ),
                                                              ),
                                                              child:
                                                                  OrderCardWidget(
                                                                order:
                                                                    orderEntity,
                                                                isDragging:
                                                                    false,
                                                                onOrderSize:
                                                                    _onOrderSize,
                                                                onBottomOrderEnd:
                                                                    widget
                                                                        .onOrderEndResizeEnd,
                                                                onTopOrderEnd:
                                                                    widget
                                                                        .onOrderStartResizeEnd,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  if (listAllNotWorkingHoursForBarber
                                                      .isNotEmpty)
                                                    ...listAllNotWorkingHoursForBarber
                                                        .where(
                                                          (notWorkingHoursEntity) {
                                                            return TimeTableHelper
                                                                .notWorkingHourCondition(
                                                              notWorkingHoursEntity
                                                                  .dateFrom,
                                                              BlocProvider.of<
                                                                          OrderFilterCubit>(
                                                                      context)
                                                                  .state
                                                                  .query,
                                                            );
                                                          },
                                                        )
                                                        .toList()
                                                        .map(
                                                          (notWorkingHoursEntity) {
                                                            // if (widget.orderFilterQuery
                                                            //     .isNotEmpty) {
                                                            //   final dt = DateTime
                                                            //       .tryParse(widget
                                                            //           .orderFilterQuery);
                                                            //   if (dt != null &&( notWorkingHoursEntity
                                                            //             .dateTo
                                                            //             .difference(dt)
                                                            //             .inDays >=
                                                            //         1 )) {
                                                            //
                                                            //     listNotWorkingHours.clear();
                                                            //
                                                            //
                                                            //     print("Remove not working hours $notWorkingHoursEntity");
                                                            //     return const SizedBox();
                                                            //   }
                                                            // }
                                                            return Positioned(
                                                              top: TimeTableHelper
                                                                  .getTopPositionForNotWorkingHours(
                                                                notWorkingHoursEntity,
                                                              ),
                                                              child:
                                                                  NotWorkingHoursCard(
                                                                notWorkingHoursEntity:
                                                                    notWorkingHoursEntity,
                                                                onDoubleTap: (entity) => widget
                                                                    .onTapNotWorkingHour
                                                                    ?.call(
                                                                        entity,
                                                                        barber),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                  ...List.generate(
                                                    IntHelper
                                                        .getCountOfCardByWorkingHours(
                                                            from, to),
                                                    (index) {
                                                      return PastTimeCardWidget(
                                                        dateTime:
                                                            DateTime.tryParse(
                                                          widget
                                                              .orderFilterQuery,
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
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
    );
  }

  _barberUpperCardWidget(BarberEntity entity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                badges.Badge(
                  badgeContent: const Text(""),
                  badgeStyle: badges.BadgeStyle(
                      badgeColor: entity.isActive ? Colors.green : Colors.red),
                  position: badges.BadgePosition.bottomEnd(
                      end: entity.avatar.isEmpty ||
                              entity.avatar.contains("placeholder.png")
                          ? 5
                          : 10),
                  child: ImageViewWidget(
                    avatar: entity.avatar,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                FittedBox(
                  child: Text(
                    "${entity.lastName[0].toUpperCase()}. ${entity.firstName}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.sideMenu,
                      fontSize: 15,
                      fontFamily: "Nunito",
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onPressed: () {
              Dialogs.timeTableBarberDialog(
                context: context,
                onTimeConfirm: (timeFrom, timeTo) {
                  widget.onNotWorkingHoursCreate.call(
                    timeFrom,
                    timeTo,
                    entity.employeeId,
                  );
                },
                onDeleteEmployeeFromTable: () {
                  listBarber.remove(entity);
                  widget.onDeleteEmployeeFromTable?.call(entity.id);

                  setState(() {});
                },
                employeeId: entity.id,
                onChangeEmployeeSchedule: () {
                  widget.onChangeEmployeeSchedule
                      .call(entity.employeeId, entity);
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
