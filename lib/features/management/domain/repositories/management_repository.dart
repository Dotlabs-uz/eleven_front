import 'package:dartz/dartz.dart';

import '../../../../core/entities/app_error.dart';
import '../entity/customer_entity.dart';
import '../entity/customer_results_entity.dart';
import '../entity/employee_entity.dart';
import '../entity/employee_results_entity.dart';

abstract class ManagementRepository {

  // ================ Customer ================ //

  Future<Either<AppError, CustomerResultsEntity>> getCustomer(
    int page,
    String searchText,
    String? ordering,
    String? startDate,
    String? endDate,
  );
  Future<Either<AppError, CustomerEntity>> saveCustomer(CustomerEntity data);
  Future<Either<AppError, bool>> deleteCustomer(CustomerEntity entity);

  // ================ Employee ================ //


  Future<Either<AppError, EmployeeResultsEntity>> getEmployee(
      int page,
      String searchText,
      );
  Future<Either<AppError, EmployeeEntity>> saveEmployee(EmployeeEntity data);
  Future<Either<AppError, bool>> deleteEmployee(EmployeeEntity entity);

}
