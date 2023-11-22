// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class NotWorkingHoursForWeeklyScheduleEntity extends Equatable {
    DateTime dateFrom;
    DateTime dateTo;

    NotWorkingHoursForWeeklyScheduleEntity({
    required this.dateFrom,
    required this.dateTo,
  });

  @override
  List<Object?> get props => [dateFrom, dateTo];
}
