import 'package:equatable/equatable.dart';

class NotWorkingHoursForBarberScheduleEntity extends Equatable {
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const NotWorkingHoursForBarberScheduleEntity({
    required this.dateFrom,
    required this.dateTo,
  });

  @override
  List<Object?> get props => [dateFrom, dateTo];
}
