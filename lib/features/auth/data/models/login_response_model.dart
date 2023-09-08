import '../../domain/entities/login_response_entity.dart';

class LoginResponseModel extends LoginResponseEntity {
  LoginResponseModel({required super.status, required super.isRegistered});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'],
      isRegistered: json['is_registered'],
    );
  }
}
