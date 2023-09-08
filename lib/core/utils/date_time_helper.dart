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

  static String dateTo24(DateTime dateTime) {
    final formatted = DateFormat('d MMM y').format(dateTime);
    return formatted;
  }
}
