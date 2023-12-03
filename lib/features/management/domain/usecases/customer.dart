import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/customer_entity.dart';
import '../entity/customer_results_entity.dart';
import '../repositories/management_repository.dart';

class GetCustomer extends UseCase<CustomerResultsEntity, CustomerParams> {
  final ManagementRepository repository;

  GetCustomer(this.repository);

  @override
  Future<Either<AppError, CustomerResultsEntity>> call(
      CustomerParams params) async {
    return await repository.getCustomer(
      params.page,
      params.searchText,
      params.ordering,
      params.startDate,
      params.endDate,
    );
  }
}
class GetCustomerById extends UseCase<CustomerEntity, String> {
  final ManagementRepository repository;

  GetCustomerById(this.repository);

  @override
  Future<Either<AppError, CustomerEntity>> call(
      String params) async {
    return await repository.getCustomerById(
      params,
    );
  }
}

class SaveCustomer extends UseCase<CustomerEntity, CustomerEntity> {
  final ManagementRepository repository;

  SaveCustomer(this.repository);

  @override
  Future<Either<AppError, CustomerEntity>> call(CustomerEntity params) async {
    return await repository.saveCustomer(params);
  }
}

class DeleteCustomer extends UseCase<void, CustomerEntity> {
  final ManagementRepository repository;

  DeleteCustomer(this.repository);

  @override
  Future<Either<AppError, void>> call(CustomerEntity params) async {
    return await repository.deleteCustomer(params);
  }
}


class CustomerParams extends Equatable {
  final int page;
  final String searchText;
  final String? ordering;
  final String? startDate;
  final String? endDate;

  const CustomerParams({
    required this.page,
    this.ordering,
    this.searchText = '',
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [page];
}
