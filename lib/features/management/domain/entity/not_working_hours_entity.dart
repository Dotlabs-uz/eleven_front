import 'package:equatable/equatable.dart';

class NotWorkingHoursEntity extends Equatable{
  final DateTime dateFrom;
  final DateTime dateTo;
  final String barberId;

  const NotWorkingHoursEntity({required this.dateFrom, required this.dateTo, required this.barberId});


  @override
  List<Object?> get props => [dateFrom,dateTo];
}