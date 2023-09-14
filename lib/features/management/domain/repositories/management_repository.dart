import 'package:dartz/dartz.dart';

import '../../../../core/entities/app_error.dart';
import '../entity/customer_entity.dart';
import '../entity/customer_results_entity.dart';

abstract class ManagementRepository {


  Future<Either<AppError, CustomerResultsEntity>> getCustomer(
    int page,
    String searchText,
    String? ordering,
    String? startDate,
    String? endDate,
  );

  Future<Either<AppError, CustomerEntity>> saveCustomer(CustomerEntity data);


  Future<Either<AppError, bool>> deleteCustomer(CustomerEntity entity);

}
