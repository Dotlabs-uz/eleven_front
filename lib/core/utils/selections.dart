import 'package:flutter/material.dart';

import '../../features/management/domain/entity/employee_schedule_entity.dart';
import '../../features/management/presentation/widgets/employee_schedule_status_widget.dart';

class StatusEmployeeScheduleEntity {
  final int status;
  final String title;

  StatusEmployeeScheduleEntity({required this.status, required this.title});
}
class Selections {
  static   List<StatusEmployeeScheduleEntity> listStatusIndex = [
    StatusEmployeeScheduleEntity(status: 0, title: "Не рабочий"),
    StatusEmployeeScheduleEntity(status: 1, title: "Рабочий"),
  ];
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
