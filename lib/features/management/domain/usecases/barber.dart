import 'package:dartz/dartz.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_results_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/barber_entity.dart';
import '../entity/customer_entity.dart';
import '../entity/customer_results_entity.dart';
import '../repositories/management_repository.dart';

class GetBarber extends UseCase<BarberResultsEntity, GetBarberParams> {
  final ManagementRepository repository;

  GetBarber(this.repository);

  @override
  Future<Either<AppError, BarberResultsEntity>> call(
      GetBarberParams params) async {
    return await repository.getBarber(
      params.page,
      params.searchText,
      params.ordering,
    );
  }
}

class SaveBarber extends UseCase<BarberEntity, BarberEntity> {
  final ManagementRepository repository;

  SaveBarber(this.repository);

  @override
  Future<Either<AppError, BarberEntity>> call(BarberEntity params) async {
    return await repository.saveBarber(params);
  }
}

class DeleteBarber extends UseCase<void, BarberEntity> {
  final ManagementRepository repository;

  DeleteBarber(this.repository);

  @override
  Future<Either<AppError, void>> call(BarberEntity params) async {
    return await repository.deleteBarber(params);
  }
}


class GetBarberParams extends Equatable {
  final int page;
  final String searchText;
  final String? ordering;

  const GetBarberParams({
    required this.page,
    this.searchText = '',
    this.ordering,
  });

  @override
  List<Object?> get props => [page];
}
