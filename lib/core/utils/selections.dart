import 'package:flutter/material.dart';

import '../../features/management/presentation/widgets/employee_schedule_status_widget.dart';

class Selections {
  static final List<EmployeeScheduleStatus> listStatus = [
    const EmployeeScheduleStatus(
      title: "P",
      color: Color(0xff99C499),
      description: 'Рабочий',
    ),
    const EmployeeScheduleStatus(
      title: "Б",
      color: Color(0xffDFBBBB),
      description: 'Больничный',
    ),
    const EmployeeScheduleStatus(
      title: "O",
      color: Color(0xffC9D6E6),
      description: 'Oтпуск',
    ),
  ];
}
