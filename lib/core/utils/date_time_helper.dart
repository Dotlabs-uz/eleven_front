import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateTimeHelper {
  static Future<DateTime?> pickDate(BuildContext context,
      {DateTime? initialDate}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    return pickedDate;
  }

  static Future<DateTime?> pickDateWithTime(BuildContext context,
      {DateTime? initialDate}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      locale: context.locale,
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // ignore: use_build_context_synchronously
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        return DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
            pickedTime.hour, pickedTime.minute);
      }
      return null;
    }

    return null;
  }

  static Future<TimeOfDay?> pickTime(BuildContext context,
      {DateTime? initialDate}) async {
    // ignore: use_build_context_synchronously
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    return pickedTime;
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
