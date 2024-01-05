import 'package:dartz/dartz.dart';
import 'package:eleven_crm/features/main/domain/entity/order_entity.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/main_repository.dart';

class SaveOrder extends UseCase<bool, OrderEntity> {
  final MainRepository repository;

  SaveOrder(this.repository);

  @override
  Future<Either<AppError, bool>> call(OrderEntity params) async {
    return await repository.saveOrder(params);
  }
}

class DeleteOrder extends UseCase<bool, String> {
  final MainRepository repository;

  DeleteOrder(this.repository);

  @override
  Future<Either<AppError, bool>> call(String params) async {
    return await repository.deleteOrder(params);
  }
}
