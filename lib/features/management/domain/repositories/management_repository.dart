import 'package:dartz/dartz.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_entity.dart';
import 'package:eleven_crm/features/management/domain/entity/barber_results_entity.dart';
import 'package:eleven_crm/features/management/domain/entity/manager_results_entity.dart';

import '../../../../core/entities/app_error.dart';
import '../../presentation/widgets/employee_schedule_widget.dart';
import '../entity/customer_entity.dart';
import '../entity/customer_results_entity.dart';
import '../entity/employee_entity.dart';
import '../entity/employee_results_entity.dart';
import '../entity/employee_schedule_entity.dart';
import '../entity/manager_entity.dart';

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

  // ================ Manager ================ //

  Future<Either<AppError, ManagerResultsEntity>> getManager(
      int page,
      String searchText,

      );
  Future<Either<AppError, ManagerEntity>> saveManager(ManagerEntity data);
  Future<Either<AppError, bool>> deleteManager(ManagerEntity entity);


  // ================ Barber ================ //

  Future<Either<AppError, BarberResultsEntity>> getBarber(
    int page,
    String searchText,
    String? ordering,
  );
  Future<Either<AppError, BarberEntity>> saveBarber(BarberEntity data);
  Future<Either<AppError, bool>> deleteBarber(BarberEntity entity);

  // ================ Employee ================ //

  Future<Either<AppError, EmployeeResultsEntity>> getEmployee(
    int page,
    String searchText,
  );
  Future<Either<AppError, EmployeeEntity>> saveEmployee(EmployeeEntity data);
  Future<Either<AppError, bool>> saveEmployeeScheduleList(List<FieldSchedule> data);
  Future<Either<AppError, bool>> deleteEmployee(EmployeeEntity entity);
}
