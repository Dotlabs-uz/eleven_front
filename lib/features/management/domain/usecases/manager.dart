import 'package:dartz/dartz.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_results_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/barber_entity.dart';
import '../entity/customer_entity.dart';
import '../entity/customer_results_entity.dart';
import '../entity/manager_entity.dart';
import '../entity/manager_results_entity.dart';
import '../repositories/management_repository.dart';

class GetManager extends UseCase<ManagerResultsEntity, GetManagerParams> {
  final ManagementRepository repository;

  GetManager(this.repository);

  @override
  Future<Either<AppError, ManagerResultsEntity>> call(
      GetManagerParams params) async {
    return await repository.getManager(
      params.page,
      params.searchText,
    );
  }
}

class SaveManager extends UseCase<ManagerEntity, ManagerEntity> {
  final ManagementRepository repository;

  SaveManager(this.repository);

  @override
  Future<Either<AppError, ManagerEntity>> call(ManagerEntity params) async {
    return await repository.saveManager(params);
  }
}

class DeleteManager extends UseCase<void, ManagerEntity> {
  final ManagementRepository repository;

  DeleteManager(this.repository);

  @override
  Future<Either<AppError, void>> call(ManagerEntity params) async {
    return await repository.deleteManager(params);
  }
}

class GetManagerParams extends Equatable {
  final int page;
  final String searchText;

  const GetManagerParams({
    required this.page,
    this.searchText = '',
  });

  @override
  List<Object?> get props => [page];
}
