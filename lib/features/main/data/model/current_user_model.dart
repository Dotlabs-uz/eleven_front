import '../../domain/entity/current_user_entity.dart';

class CurrentUserModel extends CurrentUserEntity {
  const CurrentUserModel({
    required super.id,
    required super.firstName,
    required super.avatar,
    required super.lastName,
    required super.phoneNumber,
    required super.password,
    required super.login,
    required super.role,
  });

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    return CurrentUserModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatar: json['avatar'] ?? "",
      phoneNumber: json['phone'],
      password: "",
      login: json['login'] ?? "",
      role: json['role'],
    );
  }
}
