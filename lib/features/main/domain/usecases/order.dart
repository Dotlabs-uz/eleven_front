import 'package:dartz/dartz.dart';
import 'package:eleven_crm/features/main/domain/entity/order_entity.dart';

import '../../../../core/entities/app_error.dart';
import '../../../../core/entities/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/current_user_entity.dart';
import '../repository/main_repository.dart';

class SaveOrder extends UseCase<bool,OrderEntity> {
  final MainRepository repository;

  SaveOrder(this.repository);

  @override
  Future<Either<AppError, bool>> call(OrderEntity params) async {
    return await repository.saveOrder(params);
  }
}
