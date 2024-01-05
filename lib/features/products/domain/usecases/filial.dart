import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/filial_results_entity.dart';
import '../repository/products_repository.dart';

class GetFilials extends UseCase<FilialResultsEntity, GetFilialParams> {
  final ProductsRepository repository;

  GetFilials(this.repository);

  @override
  Future<Either<AppError, FilialResultsEntity>> call(
      GetFilialParams params) async {
    return await repository.getFilials(
      params.page,
      params.searchText,
      params.ordering,
    );
  }
}



class GetFilialParams extends Equatable {
  final int page;
  final String searchText;
  final String? ordering;

  const GetFilialParams({
    required this.page,
    this.ordering,
    this.searchText = '',
  });

  @override
  List<Object?> get props => [page];
}
