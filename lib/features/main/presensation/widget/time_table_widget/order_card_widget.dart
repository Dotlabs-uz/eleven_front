import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/entities/field_entity.dart';
import 'package:eleven_crm/features/main/presensation/cubit/order/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/time_table_helper.dart';
import '../../../../management/domain/entity/not_working_hours_entity.dart';
import '../../../domain/entity/order_entity.dart';

class DragOrder {
  final bool isResizing;
  final OrderEntity orderEntity;

  DragOrder({required this.isResizing, required this.orderEntity});
}

class OrderCardWidget extends StatefulWidget {
  final OrderEntity order;
  final bool isDragging;
  final Function() onOrderSize;
  final Function(OrderEntity order) onTopOrderEnd;
  final Function(OrderEntity order) onBottomOrderEnd;

  const OrderCardWidget({
    Key? key,
    required this.order,
    required this.isDragging,
    required this.onOrderSize,
    required this.onTopOrderEnd,
    required this.onBottomOrderEnd,
  }) : super(key: key);

  @override
  State<OrderCardWidget> createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget> {
  double topPosition = 0;
  double bottomPosition = 0;

  void onDragTopUpdate(DragUpdateDetails details) {
    final minutesToChange =
        (details.delta.dy / Constants.sizeTimeTableFieldPerMinuteRound).round();
    final newOrderStart =
        widget.order.orderStart.add(Duration(minutes: minutesToChange));

    if (newOrderStart.isBefore(widget.order.orderEnd)) {
      widget.order.orderStart = newOrderStart;
      topPosition = 0;
      setState(() {});
      widget.onOrderSize.call();
    }
  }

  void onDragBottomUpdate(DragUpdateDetails details) {
    final minutesToChange =
        (details.delta.dy / Constants.sizeTimeTableFieldPerMinuteRound).round();
    final newOrderEnd =
        widget.order.orderEnd.add(Duration(minutes: minutesToChange));

    if (newOrderEnd.isAfter(widget.order.orderStart)) {
      widget.order.orderEnd = newOrderEnd;
      bottomPosition = 0;
      setState(() {});
      widget.onOrderSize.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isDragging
          ? Constants.timeTableItemWidth
          : MediaQuery.of(context).size.width,
      height: TimeTableHelper.getCardHeight(
        widget.order.orderStart,
        widget.order.orderEnd,
      ),
      color: widget.isDragging
          ? Colors.grey.shade400.withOpacity(0.3)
          : AppColors.timeTableCard,
      child: !widget.isDragging
          ? Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: AppColors.timeTableCardAppBar,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${DateFormat('HH:mm').format(widget.order.orderStart)} / ${DateFormat('HH:mm').format(widget.order.orderEnd)}",
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              child: const MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                              onTap: () {
                                BlocProvider.of<OrderCubit>(context)
                                    .delete(orderId: widget.order.id);
                              },
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
                ),
                Positioned(
                  top: 0,
                  child: Draggable<DragOrder>(
                    data: DragOrder(
                      isResizing: true,
                      orderEntity: widget.order,
                    ),
                    onDragUpdate: onDragTopUpdate,

                    onDragEnd: (details) {
                      // widget.onTopOrderEnd.call(widget.order);
                      topPosition = 0;
                    },

                    feedback: Container(
                      height: 5,
                      color: Colors.transparent,
                    ),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeUpDown,
                      child: Container(
                        height: 5,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Draggable<DragOrder>(
                    data: DragOrder(
                      isResizing: true,
                      orderEntity: widget.order,
                    ),
                    onDragUpdate: onDragBottomUpdate,
                    onDragEnd: (details) {
                      // widget.onBottomOrderEnd.call(widget.order);
                      bottomPosition = 0;
                    },


                    feedback: Container(
                      height: 5,
                      color: Colors.transparent,
                    ),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeUpDown,
                      child: Container(
                        height: 5,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
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
