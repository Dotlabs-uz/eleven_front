import 'package:flutter/material.dart';

import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/time_table_helper.dart';
import '../../../../management/domain/entity/not_working_hours_entity.dart';
import '../../../domain/entity/order_entity.dart';
import 'order_card_widget.dart';

class FieldCardWidget extends StatefulWidget {
  final int hour;
  final bool isFirstSection;
  final String barberId;
  final Function(int hour ,int minute) onFieldTap;
  final Function() onPositionChanged;
  final List<NotWorkingHoursEntity> notWorkingHours;

  const FieldCardWidget({
    super.key,
    required this.hour,
    required this.isFirstSection,
    required this.onPositionChanged,
    required this.onFieldTap,
    required this.barberId,
    required this.notWorkingHours,
  });

  @override
  State<FieldCardWidget> createState() => _FieldCardWidgetState();
}

class _FieldCardWidgetState extends State<FieldCardWidget> {
  // bool isCardAllowedToDrag(
  //     OrderEntity order, List<NotWorkingHoursEntity> notWorkingHours) {
  //   final orderStart = order.orderStart;
  //   final orderEnd = order.orderEnd;
  //
  //   for (final notWorkingHour in notWorkingHours) {
  //     final notWorkingHourStart = notWorkingHour.dateFrom;
  //     final notWorkingHourEnd = notWorkingHour.dateTo;
  //
  //     final diffInMinutes =
  //         (orderStart.difference(notWorkingHourStart).inHours * 60) +
  //             (orderStart.difference(notWorkingHourStart).inMinutes % 60);
  //
  //     print("Not working hours start diff ${diffInMinutes}");
  //
  //     // if (orderEnd.difference(other)) {
  //     //   return false; // Заказ пересекается с "Not Working Hours", не разрешаем перенос
  //     // }
  //   }
  //
  //   return true; // Время заказа не пересекается с "Not Working Hours" и занимает все время Field, разрешаем перенос
  // }

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
              child: DragTarget<DragOrder>(
                onAcceptWithDetails: (details) {
                  print(
                      "On Accept With details ${details.data}, Offset ${details.offset}");
                },
                onAccept: (dragOrder) async {
                  if (dragOrder.isResizing == false) {
                    TimeTableHelper.onAccept(
                      dragOrder.orderEntity,
                      widget.hour,
                      minute,
                      widget.barberId,
                      widget.onPositionChanged,
                    );
                  }

                  // if (true) {
                  //
                  //   TODO Add Not working hours logic
                  //
                  // } else {
                  //   await confirm(
                  //     context,
                  //     title: const Text('confirming').tr(),
                  //     content: const Text('deleteConfirm').tr(),
                  //     textOK: const Text('yes').tr(),
                  //   );
                  // }
                },
                builder: (context, candidateData, rejectedData) {
                  return InkWell(
                    onTap: () =>widget.onFieldTap.call (widget.hour, minute) ,
                    child: Ink(
                      decoration: BoxDecoration(
                        color: candidateData.isNotEmpty
                            ? candidateData.first != null &&
                                    candidateData.first!.isResizing == true
                                ? Colors.transparent
                                : Colors.orange
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
                    ),
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
