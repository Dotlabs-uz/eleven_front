import 'package:equatable/equatable.dart';

import 'barber_entity.dart';

class BarberResultsEntity  extends Equatable{
  final int count;
  final int pageCount;
  final List<BarberEntity> results;

  const BarberResultsEntity({
    required this.count,
    required this.pageCount,
    required this.results,
  });

  @override
  List<Object?> get props => [
    count,
    pageCount,
    results,
  ];
}
