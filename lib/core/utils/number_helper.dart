
import 'package:easy_localization/easy_localization.dart';

class NumberHelper {
  static String formatNumber(int value) {
    var formatter = NumberFormat('#,###');
    return formatter.format(value.toInt()).replaceAll(',', ' ').toString();
  }
  static String formatDouble(double number) {
    final formattedNumber = number.toStringAsFixed(2);

    return formattedNumber;
  }
}