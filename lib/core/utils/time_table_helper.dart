import '../../features/main/domain/entity/order_entity.dart';
import '../../features/management/domain/entity/not_working_hours_entity.dart';
import 'constants.dart';

class TimeTableHelper {
  static double getCardHeight(DateTime from, DateTime to) {
    final differenceInMinutes =
        (to.difference(from).inHours * 60) + to.difference(from).inMinutes % 60;

   print("diff $differenceInMinutes");

    if (differenceInMinutes <= 0) {
      return Constants.timeTableItemHeight;
    }

    print("Cart h ${differenceInMinutes * Constants.sizeTimeTableFieldPerMinuteRound}");

    return differenceInMinutes * Constants.sizeTimeTableFieldPerMinuteRound;
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

  static onAccept(OrderEntity order, int hour, int minute, String barberId,
      Function() onAllChanged) {
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
    onAllChanged.call();
  }
}
