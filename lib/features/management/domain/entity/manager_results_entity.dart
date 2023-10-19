import 'package:equatable/equatable.dart';

import 'barber_entity.dart';
import 'manager_entity.dart';

class ManagerResultsEntity  extends Equatable{
  final int count;
  final int pageCount;
  final List<ManagerEntity> results;

  const ManagerResultsEntity({
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
