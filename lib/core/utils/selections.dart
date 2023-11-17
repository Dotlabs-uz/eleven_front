import 'package:flutter/material.dart';

import '../../features/management/domain/entity/employee_schedule_entity.dart';
import '../../features/management/presentation/widgets/employee_schedule_status_widget.dart';

class Selections {
  static const List<EmployeeScheduleStatusField> listStatus = [
    EmployeeScheduleStatusField(
      title: "P",
      color: Color(0xff99C499),
      description: 'Рабочий',
      status: EmployeeScheduleStatus.work,
    ),
    EmployeeScheduleStatusField(
      title: "НР",
      color: Color(0xffDFBBBB),
      description: 'Не рабочий',
      status: EmployeeScheduleStatus.notWork,
    ),
  ];
}
