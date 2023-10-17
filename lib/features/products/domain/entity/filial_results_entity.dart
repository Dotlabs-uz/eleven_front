

import 'package:eleven_crm/features/products/domain/entity/service_product_category_entity.dart';
import 'package:equatable/equatable.dart';

import 'filial_entity.dart';


class FilialResultsEntity extends Equatable {
  final int count;
  final int pageCount;
  final List<FilialEntity> results;

  const FilialResultsEntity({
    required this.count,
    required this.pageCount,
    required this.results,
  });

  @override
  List<Object?> get props => [count, pageCount, results,];


}
