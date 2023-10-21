import '../../features/main/domain/entity/order_entity.dart';
import 'constants.dart';

class TimeTableHelper {
  static double getCardHeight(DateTime from, DateTime to) {
    final differenceInMinutes = (to.difference(from).inHours * 60) + to.difference(from).inMinutes % 60;

    if (differenceInMinutes <= 0) {
      return Constants.timeTableItemHeight;
    }

    return differenceInMinutes * Constants.sizeTimeTableFieldPerMinuteRound;
  }

  static onAccept(OrderEntity order, int hour, int minute, String barberId,  Function() onAllChanged) {

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
