import 'package:equatable/equatable.dart';

class NotWorkingHoursEntity extends Equatable {
  final DateTime dateFrom;
  final DateTime dateTo;

  const NotWorkingHoursEntity({
    required this.dateFrom,
    required this.dateTo,
  });

  @override
  List<Object?> get props => [dateFrom, dateTo];
}
