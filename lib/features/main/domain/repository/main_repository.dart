import 'package:dartz/dartz.dart';


import '../../../../core/entities/app_error.dart';
import '../entity/current_user_entity.dart';
import '../entity/order_entity.dart';


abstract class MainRepository {
  Future<Either<AppError, CurrentUserEntity>> getCurrentUser();
  Future<Either<AppError, bool>> saveCurrentUser(CurrentUserEntity currentUser);
  Future<Either<AppError, bool>> saveOrder(OrderEntity order);
  Future<Either<AppError, bool>> savePhoto(List<int> file, String userId,String role);
  Future<Either<AppError, bool>> deleteOrder(String orderId);
  Future<Either<AppError, bool>> saveNotWorkingHours(DateTime from, DateTime to, String employeeId);

}
