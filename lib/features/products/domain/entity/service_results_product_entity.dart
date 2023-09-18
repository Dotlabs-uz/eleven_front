import 'package:equatable/equatable.dart';

import 'service_product_entity.dart';

class ServiceResultsProductEntity extends Equatable {
  final int count;
  final int pageCount;
  final List<ServiceProductEntity> results;

  const ServiceResultsProductEntity({
    required this.count,
    required this.pageCount,
    required this.results,
  });

  @override
  List<Object?> get props => [count, pageCount, results,];


}
