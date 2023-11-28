import 'package:cached_network_image/cached_network_image.dart';
import 'package:eleven_crm/core/components/empty_widget.dart';
import 'package:eleven_crm/features/main/presensation/cubit/order_filter_cubit.dart';
import 'package:eleven_crm/features/main/presensation/cubit/order_filter_cubit.dart';
import 'package:eleven_crm/features/main/presensation/widget/time_table_widget/past_time_card_widget.dart';
import 'package:eleven_crm/features/main/presensation/widget/time_table_widget/time_table_ruler_widget.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/dialogs.dart';
import '../../../../../core/utils/int_helper.dart';
import '../../../../../core/utils/time_table_helper.dart';
import '../../../../management/domain/entity/not_working_hours_entity.dart';
import '../../../../management/presentation/cubit/employee/employee_cubit.dart';
import '../../../domain/entity/order_entity.dart';
import 'field_card_widget.dart';
import 'no_working_hours_card_widget.dart';
import 'order_card_widget.dart';

// ignore: must_be_immutable

class TimeTableCopyWidget extends StatefulWidget {
  final List<BarberEntity> listBarbers;
  final List<OrderEntity> listOrders;
  final Function(DateTime from, DateTime to, String employeeId)
      onNotWorkingHoursCreate;
  final Function(String employee)? onDeleteEmployeeFromTable;
  final Function(OrderEntity)? onOrderClick;
  final String orderFilterQuery;
  final Function(OrderEntity)? onOrderDragEnd;
  final Function(int hour, int minute, String barberId)? onFieldTap;
  final Function(NotWorkingHoursEntity, BarberEntity)? onTapNotWorkingHours;
  final Function(OrderEntity order)? onOrderStartResizeEnd;
  final Function(OrderEntity order)? onOrderEndResizeEnd;

  const TimeTableCopyWidget({
    Key? key,
    required this.listBarbers,
    required this.onNotWorkingHoursCreate,
    this.onDeleteEmployeeFromTable,
    this.orderFilterQuery = "",
    this.onFieldTap,
    this.onOrderDragEnd,
    this.onOrderClick,
    this.onTapNotWorkingHours,
    required this.listOrders,
    this.onOrderStartResizeEnd,
    this.onOrderEndResizeEnd,
  }) : super(key: key);

  @override
  State<TimeTableCopyWidget> createState() => _TimeTableCopyWidgetState();
}

class _TimeTableCopyWidgetState extends State<TimeTableCopyWidget> {
  final DateTime from = DateTime(2023, 10, 7, 8);
  final DateTime to = DateTime(2023, 10, 7, 22);

  static final List<BarberEntity> listBarber = [];
  static final List<OrderEntity> listOrders = [];
  static List<NotWorkingHoursEntity> listNotWorkingHours = [];

  @override
  void didUpdateWidget(covariant TimeTableCopyWidget oldWidget) {
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
    listNotWorkingHours.clear();

    final List<BarberEntity> employeeListData = widget.listBarbers
        .where((element) => element.inTimeTable == true)
        .toList();

    listBarber.addAll(employeeListData);
    listOrders.addAll(widget.listOrders);
  }

  @override
  void dispose() {
    listBarber.clear();
    listOrders.clear();
    listNotWorkingHours.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: listBarber.isEmpty
          ? const EmptyWidget()
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: widget.listBarbers.length,
                itemBuilder: (context, index) {
                  final barberEntity = widget.listBarbers[index];
                  return _Item(
                    barberEntity: barberEntity,
                    timeFrom: from,
                    timeTo: to,
                    index: index,
                    onOrderDragEnd: widget.onOrderDragEnd,
                    onFieldTap: widget.onFieldTap,
                    onTapNotWorkingHours: widget.onTapNotWorkingHours,
                    onOrderStartResizeEnd: widget.onOrderStartResizeEnd,
                    onOrderEndResizeEnd: widget.onOrderEndResizeEnd,
                    onNotWorkingHoursCreate: widget.onNotWorkingHoursCreate,
                    onDeleteEmployeeFromTable: widget.onDeleteEmployeeFromTable,
                    onOrderClick: widget.onOrderClick,
                    orderFilterQuery: widget.orderFilterQuery, listOrders: [], listNotWorkingHours: [],
                  );
                },
              ),
            ),
    );
  }
}

class _Item extends StatefulWidget {
  final BarberEntity barberEntity;
  final DateTime timeFrom;
  final List<OrderEntity> listOrders;
  final List<NotWorkingHoursEntity> listNotWorkingHours;
  final DateTime timeTo;
  final int index;
  final Function(OrderEntity)? onOrderDragEnd;
  final Function(int hour, int minute, String barberId)? onFieldTap;
  final Function(NotWorkingHoursEntity, BarberEntity)? onTapNotWorkingHours;
  final Function(OrderEntity order)? onOrderStartResizeEnd;
  final Function(OrderEntity order)? onOrderEndResizeEnd;
  final Function(DateTime from, DateTime to, String employeeId)
      onNotWorkingHoursCreate;
  final Function(String employee)? onDeleteEmployeeFromTable;
  final Function(OrderEntity)? onOrderClick;
  final String orderFilterQuery;

  const _Item({
    Key? key,
    required this.listOrders,
    required this.barberEntity,
    required this.timeFrom,
    required this.timeTo,
    required this.index,
    required this.onOrderDragEnd,
    required this.onFieldTap,
    required this.onTapNotWorkingHours,
    required this.onOrderStartResizeEnd,
    required this.onOrderEndResizeEnd,
    required this.onNotWorkingHoursCreate,
    required this.onDeleteEmployeeFromTable,
    required this.onOrderClick,
    required this.orderFilterQuery, required this.listNotWorkingHours,
  }) : super(key: key);

  @override
  State<_Item> createState() => _ItemState();
}

class _ItemState extends State<_Item> {
  static List<OrderEntity> localOrders = [];
  static List<NotWorkingHoursEntity> listNotWorkingHours = [];




  @override
  void didUpdateWidget(covariant _Item oldWidget) {

    if(localOrders.length != widget.listOrders.length || listNotWorkingHours.length != widget.listNotWorkingHours.length) {

  initialize();
    }

    super.didUpdateWidget(oldWidget);
  }

@override
  initState() {
  initialize();
  super.initState();
}


  void initialize() {
    localOrders.clear();
    listNotWorkingHours.clear();


    localOrders = widget.listOrders;
    listNotWorkingHours = widget.listNotWorkingHours;

  }


  _onOrderSize() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          child: Row(
            children: [
              if (widget.index == 0)
                SizedBox(
                  width: Constants.rulerWidth,
                ),
              if (widget.index == 0) Container(width: 10),
              Expanded(
                child: _barberUpperCardWidget(widget.barberEntity),
              ),
            ],
          ),
        ),
        // Expanded(
        //   child: SingleChildScrollView(
        //     padding: EdgeInsets.zero,
        //     clipBehavior: Clip.antiAlias,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Row(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             TimeTableRulerWidget(
        //               timeFrom: widget.timeFrom,
        //               timeTo: widget.timeTo,
        //             ),
        //             Expanded(
        //               child: Padding(
        //                 padding: const EdgeInsets.only(top: 24),
        //                 child: Stack(
        //                   children: [
        //                     Container(
        //                       decoration: BoxDecoration(
        //                         border: Border(
        //                           bottom: BorderSide(
        //                             width: 1,
        //                             color: Colors.grey.shade400,
        //                           ),
        //                           top: BorderSide(
        //                             width: 1,
        //                             color: Colors.grey.shade400,
        //                           ),
        //                         ),
        //                       ),
        //                       child: Column(
        //                         children: [
        //                           ...List.generate(
        //                             IntHelper.getCountOfCardByWorkingHours(
        //                                 widget.timeFrom, widget.timeTo),
        //                             (localIndex) {
        //                               final hour =
        //                                   widget.timeFrom.hour + localIndex;
        //
        //                               return FieldCardWidget(
        //                                 isFirstSection: widget.index == 0,
        //                                 hour: hour,
        //                                 barberId: widget.barberEntity.id,
        //                                 onDragEnded: (localOrder, confirm) {
        //                                   setState(() {});
        //
        //                                   if (confirm) {
        //                                     widget.onOrderDragEnd
        //                                         ?.call(localOrder);
        //                                   }
        //                                 },
        //                                 notWorkingHours:
        //                                     widget.barberEntity.notWorkingHours,
        //                                 onFieldTap: (hour, minute) =>
        //                                     widget.onFieldTap?.call(hour,
        //                                         minute, widget.barberEntity.id),
        //                               );
        //                             },
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                     if (localOrders.isNotEmpty)
        //                       ...localOrders.map(
        //                         (orderEntity) {
        //                           return Positioned(
        //                             // top: Constants.timeTableItemHeight +Constants.timeTableItemHeight  ,
        //                             top: TimeTableHelper.getTopPositionForOrder(
        //                               orderEntity,
        //                             ),
        //                             child: GestureDetector(
        //                               onDoubleTap: () => widget.onOrderClick
        //                                   ?.call(orderEntity),
        //                               child: Draggable<DragOrder>(
        //                                 data: DragOrder(
        //                                   isResizing: false,
        //                                   orderEntity: orderEntity,
        //                                 ),
        //                                 childWhenDragging: OrderCardWidget(
        //                                   order: orderEntity,
        //                                   isDragging: true,
        //                                   onOrderSize: _onOrderSize,
        //                                 ),
        //                                 feedback: Opacity(
        //                                   opacity: 0.6,
        //                                   child: Material(
        //                                     child: OrderCardWidget(
        //                                       order: orderEntity,
        //                                       isDragging: true,
        //                                       onOrderSize: _onOrderSize,
        //                                     ),
        //                                   ),
        //                                 ),
        //                                 child: OrderCardWidget(
        //                                   order: orderEntity,
        //                                   isDragging: false,
        //                                   onOrderSize: _onOrderSize,
        //                                   onBottomOrderEnd:
        //                                       widget.onOrderEndResizeEnd,
        //                                   onTopOrderEnd:
        //                                       widget.onOrderStartResizeEnd,
        //                                 ),
        //                               ),
        //                             ),
        //                           );
        //                         },
        //                       ),
        //                     if (listNotWorkingHours.isNotEmpty)
        //                       ...listNotWorkingHours
        //                           .where(
        //                             (notWorkingHoursEntity) {
        //                               return TimeTableHelper
        //                                   .notWorkingHourCondition(
        //                                 notWorkingHoursEntity.dateFrom,
        //                                 widget.orderFilterQuery,
        //                               );
        //                             },
        //                           )
        //                           .toList()
        //                           .map(
        //                             (notWorkingHoursEntity) {
        //                               // if (widget.orderFilterQuery
        //                               //     .isNotEmpty) {
        //                               //   final dt = DateTime
        //                               //       .tryParse(widget
        //                               //           .orderFilterQuery);
        //                               //   if (dt != null &&( notWorkingHoursEntity
        //                               //             .dateTo
        //                               //             .difference(dt)
        //                               //             .inDays >=
        //                               //         1 )) {
        //                               //
        //                               //     listNotWorkingHours.clear();
        //                               //
        //                               //
        //                               //     print("Remove not working hours $notWorkingHoursEntity");
        //                               //     return const SizedBox();
        //                               //   }
        //                               // }
        //                               return Positioned(
        //                                 top: TimeTableHelper
        //                                     .getTopPositionForNotWorkingHours(
        //                                   notWorkingHoursEntity,
        //                                 ),
        //                                 child: NotWorkingHoursCard(
        //                                   notWorkingHoursEntity:
        //                                       notWorkingHoursEntity,
        //                                   onDoubleTap: (entity) =>
        //                                       widget.onTapNotWorkingHours?.call(
        //                                           entity, widget.barberEntity),
        //                                 ),
        //                               );
        //                             },
        //                           ),
        //                     ...List.generate(
        //                       IntHelper.getCountOfCardByWorkingHours(
        //                           widget.timeFrom, widget.timeTo),
        //                       (index) {
        //                         return PastTimeCardWidget(
        //                           dateTime: DateTime.tryParse(
        //                             widget.orderFilterQuery,
        //                           ),
        //                         );
        //                       },
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
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
                Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: entity.avatar.isEmpty
                        ? Assets.tAvatarPlaceHolder
                        : entity.avatar,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),

                  // decoration: BoxDecoration(
                  //   shape: BoxShape.circle,
                  //   image: entity.avatar.isEmpty
                  //       ? const DecorationImage(
                  //           image: AssetImage(
                  //             Assets.tAvatarPlaceHolder,
                  //           ),
                  //           fit: BoxFit.cover,
                  //         )
                  //       : DecorationImage(
                  //           image: NetworkImage(
                  //             entity.avatar,
                  //           ),
                  //           fit: BoxFit.cover,
                  //         ),
                  // ),
                ),
                const SizedBox(height: 5),
                FittedBox(
                  child: Text(
                    "${entity.firstName} ${entity.lastName}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.sideMenu,
                      fontSize: 14,
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
              Dialogs.timeTableEmployeeDialog(
                context: context,
                onTimeConfirm: (timeFrom, timeTo) {
                  widget.onNotWorkingHoursCreate.call(
                    timeFrom,
                    timeTo,
                    entity.id,
                  );
                },
                // onDeleteEmployeeFromTable: () {
                //   listBarber.remove(entity);
                //   widget.onDeleteEmployeeFromTable?.call(entity.id);
                //
                //   setState(() {});
                // },

                onDeleteEmployeeFromTable: () {
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
