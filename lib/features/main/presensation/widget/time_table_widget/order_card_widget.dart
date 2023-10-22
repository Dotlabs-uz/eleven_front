import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/time_table_helper.dart';
import '../../../../management/domain/entity/not_working_hours_entity.dart';
import '../../../domain/entity/order_entity.dart';

class OrderCardWidget extends StatefulWidget {
  final OrderEntity order;
  final bool isDragging;

  const OrderCardWidget({
    Key? key,
    required this.order,
    required this.isDragging,
  }) : super(key: key);

  @override
  State<OrderCardWidget> createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.timeTableItemWidth,
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
