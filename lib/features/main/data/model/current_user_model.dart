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
      phoneNumber: json['phone'] ?? 99,
      password: "",
      login: json['login'] ?? "",
      role: json['role'],
    );
  }

  factory CurrentUserModel.fromEntity(CurrentUserEntity entity) {
    return CurrentUserModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      avatar: entity.avatar,
      phoneNumber: entity.phoneNumber,
      password: entity.password,
      login: entity.login,
      role: entity.role,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['_id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phone'] = phoneNumber;
    data['login'] = login;
    data['role'] = role;

    return data;
  }
}
