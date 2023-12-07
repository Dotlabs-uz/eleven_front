import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
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
  final Function(int hour, int minute) onFieldTap;
  final Function(OrderEntity order, bool withConfirm) onDragEnded;
  final List<NotWorkingHoursEntity> notWorkingHours;

  const FieldCardWidget({
    super.key,
    required this.hour,
    required this.isFirstSection,
    required this.onDragEnded,
    required this.onFieldTap,
    required this.barberId,
    required this.notWorkingHours,
  });

  @override
  State<FieldCardWidget> createState() => _FieldCardWidgetState();
}

class _FieldCardWidgetState extends State<FieldCardWidget> {
  bool isCardAllowedToDrag(
      OrderEntity order, List<NotWorkingHoursEntity> notWorkingHours) {
    final orderStart = order.orderStart;
    final orderEnd = order.orderEnd;

    for (final notWorkingHour in notWorkingHours) {
      final notWorkingStart = notWorkingHour.dateFrom;
      final notWorkingEnd = notWorkingHour.dateTo;

      // if (orderStart.isAfter(notWorkingStart) &&
      //     orderEnd.isBefore(notWorkingEnd)) {
      //   return true; // Время заказа пересекается с "Not Working Hours", не разрешаем перенос
      // }
      //
      // if (orderStart.isAfter(notWorkingStart) &&
      //     orderStart.isBefore(notWorkingEnd)) {
      //   return false; // Время заказа начинается во время "Not Working Hours", не разрешаем перенос
      // }
      //
      // if (orderEnd.isAfter(notWorkingStart) &&
      //     orderEnd.isBefore(notWorkingEnd)) {
      //   return false; // Время заказа заканчивается во время "Not Working Hours", не разрешаем перенос
      // }
      //
      // if (orderStart.isAtSameMomentAs(notWorkingStart) ||
      //     orderEnd.isAtSameMomentAs(notWorkingEnd)) {
      //   return false; // Время заказа точно соответствует началу или концу "Not Working Hours", не разрешаем перенос
      // }
    }

    return true; // Время заказа не пересекается с "Not Working Hours", разрешаем перенос
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: Constants.timeTableItemHeight,
        minWidth: 444,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black26,
          ),
        ),
        // border: Border.all(width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          4,
          (index) {
            int minute =
                (index) * 15;

            if (minute >= 60) {
              minute = 0;
            }
            return Expanded(
              child: DragTarget<DragOrder>(
                onAcceptWithDetails: (details) {
                  print(
                    "On Accept With details ${details.data}, Offset ${details.offset}",
                  );
                },
                onAccept: (dragOrder) async {
                  if (dragOrder.isResizing == false) {
                    OrderEntity localOrder = dragOrder.orderEntity;

                    localOrder = TimeTableHelper.onAccept(
                      localOrder,
                      widget.hour,
                      minute,
                      widget.barberId,
                      (p0) {
                        widget.onDragEnded.call(p0, false);
                      },
                    );
                    print("Drag order ${localOrder.orderStart}");
                    if (isCardAllowedToDrag(
                        localOrder, widget.notWorkingHours)) {
                      TimeTableHelper.onAccept(
                        dragOrder.orderEntity,
                        widget.hour,
                        minute,
                        widget.barberId,
                        (p0) {
                          widget.onDragEnded.call(p0, true);
                        },
                      );
                    } else {
                      await confirm(
                        context,
                        title: const Text('draggable').tr(),
                        content: const Text('youCantDrragOrder').tr(),
                        textOK: const Text('ok').tr(),
                        enableCancel: false,
                      );
                    }
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  return Item(
                    onTap: () {
                      widget.onFieldTap.call(widget.hour, minute);
                    },
                    candidateData: candidateData,
                    hour: widget.hour,
                    minute: minute,
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

class Item extends StatefulWidget {
  final Function() onTap;
  final List<DragOrder?> candidateData;
  final int hour;
  final int minute;
  const Item(
      {Key? key,
      required this.onTap,
      required this.candidateData,
      required this.hour,
      required this.minute})
      : super(key: key);

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool isHover = false;
  static List<DragOrder?> candidateData = [];

  @override
  void didUpdateWidget(covariant Item oldWidget) {

    if(candidateData.length !=  widget.candidateData.length) {
      candidateData = widget.candidateData;
      isHover = false;
    }


    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    isHover = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (value) {
        if (widget.candidateData.isNotEmpty) return;
        if (value) {
          setState(() {
            isHover = true;
          });
        } else {
          setState(() {
            isHover = false;
          });
        }
      },
      onTap: () => widget.onTap.call(),
      child: Ink(
        decoration: BoxDecoration(
          color: isHover
              ? Colors.pink.shade400
              : widget.candidateData.isNotEmpty
                  ? widget.candidateData.first != null &&
                          widget.candidateData.first!.isResizing == true
                      ? Colors.transparent
                      : Colors.orange
                  : Colors.white,
          border: Border.all(
            width: 0.3,
            color: Colors.black26,
          ),
        ),
        width: double.infinity,
        child: isHover == false
            ? const SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 2),
                    child: Text(
                      "${widget.hour}:${widget.minute == 0 ? "00" : widget.minute}",
                      style: TextStyle(
                        color: isHover ? Colors.white : Colors.grey.shade400,
                        fontSize: isHover ? 14 : 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
