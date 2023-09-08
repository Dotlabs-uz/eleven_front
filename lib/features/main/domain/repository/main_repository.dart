import 'package:dartz/dartz.dart';


import '../../../../core/entities/app_error.dart';


abstract class MainRepository {
  Future<Either<AppError, String>> test();

}
