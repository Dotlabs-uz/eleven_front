import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateTimeHelper {
  static Future<DateTime?> pickDateTime(BuildContext context,
      {DateTime? initialDate}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    return pickedDate;
  }

  static String formatToFilter(DateTime dt) {
    return DateFormat('yyyy-MM-dd 00:mm:ss').format(dt).toString();
  }

  static String formatForTable(DateTime? dt) {
    if (dt == null) return "";
    return DateFormat('yyyy-MM-dd').format(dt).toString();
  }

  static String formatTimeAndDateForTable(DateTime? dt) {
    if (dt == null) return "";
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dt).toString();
  }
}
