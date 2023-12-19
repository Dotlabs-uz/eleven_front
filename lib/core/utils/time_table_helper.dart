import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/main/domain/entity/order_entity.dart';
import '../../features/main/presensation/cubit/order_filter_cubit.dart';
import '../../features/management/domain/entity/not_working_hours_entity.dart';
import 'constants.dart';

class TimeTableHelper {
  static double getCardHeight(DateTime from, DateTime to) {
    final differenceInMinutes =
        (to.difference(from).inHours * 60) + to.difference(from).inMinutes % 60;

    if (differenceInMinutes <= 0) {
      return Constants.timeTableItemHeight;
    }

    return differenceInMinutes * Constants.sizeTimeTableFieldPerMinuteRound;
  }

  static double getPastTimeHeight(
      DateTime from, DateTime to, DateTime? filter) {

    if (filter != null) {

      final fromFormatted  = DateTime.parse(DateFormat('yyyy-MM-dd').format(from));
      final filterFormat  = DateTime.parse(DateFormat('yyyy-MM-dd').format(filter));
      final diffDays = fromFormatted.difference(filterFormat).inDays;


      if(diffDays.isNegative) {
        return 0;
      }

      if(diffDays >= 1 ) {
        return Constants.timeTableItemHeight * (Constants.endWork.toInt()  - Constants.startWork.toInt());
      }

    }

    final differenceInMinutes =
        (to.difference(from).inHours * 60) + to.difference(from).inMinutes % 60;


    if (differenceInMinutes <= 0) {
      return Constants.timeTableItemHeight;
    }

    final h = (differenceInMinutes * Constants.sizeTimeTableFieldPerMinuteRound).toDouble();

    return h >= 1200 ? 1200 : h;
  }

  static double getTopPositionForOrder(OrderEntity order) {
    if (order.orderStart.hour == Constants.startWork) {
      final result = (order.orderStart.minute).toDouble();

      return result * Constants.sizeTimeTableFieldPerMinuteRound;
    }

    double top = Constants.startWork;

    top -= order.orderStart.hour;

    final formatted = top / -1;

    double height = 0;

    for (var i = 0; i < formatted; i++) {
      height += Constants.timeTableItemHeight;
    }

    height +=
        order.orderStart.minute * Constants.sizeTimeTableFieldPerMinuteRound;

    return height;
  }

  static double getTopPositionForNotWorkingHours(NotWorkingHoursEntity entity) {
    final from = entity.dateFrom;
    if (from.hour == Constants.startWork) {
      final result = (from.minute).toDouble();

      return result * Constants.sizeTimeTableFieldPerMinuteRound;
    }

    double top = Constants.startWork;

    top -= from.hour;

    final formatted = top / -1;

    double height = 0;

    for (var i = 0; i < formatted; i++) {
      height += Constants.timeTableItemHeight;
    }

    height += from.minute * Constants.sizeTimeTableFieldPerMinuteRound;

    return height;
  }

  static notWorkingHourCondition(DateTime dateTimeFrom, String query) {


    if (query.isNotEmpty) {
      final dt = DateTime.tryParse(query);

      if (dt != null) {
        if (dateTimeFrom.day == dt.day &&
            dateTimeFrom.month == dt.month &&
            dateTimeFrom.year == dt.year) {
          // print("get working hours $dateTimeFrom");
          return true;
        }
        return false;
      }
    }
    else {
      final nowDateTime = DateTime.now();
      if (dateTimeFrom.day == nowDateTime.day &&
          dateTimeFrom.month == nowDateTime.month &&
          dateTimeFrom.year == nowDateTime.year) {
        // print("get working hours $dateTimeFrom");
        return true;
      }
      return false;
    }


  }

  static OrderEntity onAccept(OrderEntity order, int hour, int minute, String barberId,
      Function(OrderEntity) onAllChanged) {
    final orderFrom = order.orderStart;
    final orderTo = order.orderEnd;

    final newOrderStart = DateTime(
      orderFrom.year,
      orderFrom.month,
      orderFrom.day,
      hour,
      minute,
    );

    final durationDiff = newOrderStart.difference(orderFrom);

    // Обновление времени начала заказа
    order.orderStart = newOrderStart;

    // Обновление времени окончания заказа
    final newOrderEnd = orderTo.add(durationDiff);

    order.orderEnd = newOrderEnd;

    // Обновление идентификатора парикмахера
    order.barberId = barberId;

    // Вызов колбэка для обновления позиции
    onAllChanged.call(order);

    return order;
  }
}
