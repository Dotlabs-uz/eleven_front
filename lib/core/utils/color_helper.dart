import 'package:eleven_crm/core/utils/string_helper.dart';
import 'package:flutter/material.dart';

import '../../features/management/domain/entity/employee_schedule_entity.dart';

class ColorHelper {
  static Color getColorForCalendar(int day, int month, int year) {
    final result = StringHelper.getDayOfWeekType(
      DateTime(year, month, day),
    );
    if (result == 'saSmall' || result == 'suSmall') {
      return Colors.red;
    }
    return Colors.black;
  }

  static Color getColorForScheduleByStatus(int status) {

    if(status ==  EmployeeScheduleStatus.work.index) {
      return const Color(0xff99C499);

    }else if(status ==  EmployeeScheduleStatus.sick.index) {
      return const Color(0xffDFBBBB);
    }else if(status ==  EmployeeScheduleStatus.vacation.index ) {
      return const Color(0xffC9D6E6);
    }

      return Colors.transparent;

  }
}
