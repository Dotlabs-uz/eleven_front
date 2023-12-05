import '../../features/management/domain/entity/employee_schedule_entity.dart';

enum Weekday { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class StringHelper {
  static String monthName({required int month}) {
    final Map<int, String> map = {
      1: 'January',
      2: 'February',
      3: 'March',
      4: 'April',
      5: 'May',
      6: 'June',
      7: 'July',
      8: 'August',
      9: 'September',
      10: 'October',
      11: 'November',
      12: 'December',
    };

    return map[month] ?? "Not Found!";
  }

  static int getDaysByMonthIndex({required int month}) {
    final Map<int, int> daysInMonth = {
      1: 31,
      2: 28,
      3: 31,
      4: 30,
      5: 31,
      6: 30,
      7: 31,
      8: 31,
      9: 30,
      10: 31,
      11: 30,
      12: 31,
    };

    return daysInMonth[month] ?? 31;
  }

  static Weekday getWeekDayByDate(int day, int month, int year) {
    if (month < 3) {
      month += 12;
      year--;
    }
    int k = year % 100;
    int j = year ~/ 100;
    int dayOfWeek =
        (day + (13 * (month + 1) ~/ 5) + k + (k ~/ 4) + (j ~/ 4) - 2 * j) % 7;

    return Weekday.values[dayOfWeek];
  }


  static String getDayOfWeekTypeForBarberProfile(int day) {

    switch (day) {
      case 1:
        return "monSmall";
      case 2:
        return "tueSmall";
      case 3:
        return "wedSmall";
      case 4:
        return "thSmall";
      case 5:
        return "frSmall";
      case 6:
        return "saSmall";
      case 0:
        return "suSmall";
      default:
        return "Неверный день недели";
    }
  }

  static String getDayOfWeekType(DateTime dateTime) {
    final date = dateTime;
    final dayOfWeek = date.weekday;

    switch (dayOfWeek) {
      case 1:
        return "monSmall";
      case 2:
        return "tueSmall";
      case 3:
        return "wedSmall";
      case 4:
        return "thSmall";
      case 5:
        return "frSmall";
      case 6:
        return "saSmall";
      case 7:
        return "suSmall";
      default:
        return "Неверный день недели";
    }
  }

  static String getTitleForScheduleByStatus(int status) {
    if (status == EmployeeScheduleStatus.work.index) {
      return "Р";
    } else if (status == EmployeeScheduleStatus.notWork.index) {
      return "НР";
    }

    return "Error";
  }

  static String getCardNumberForCard(String cardNumber) {
    return cardNumber.substring(cardNumber.length - 4);
  }
}
