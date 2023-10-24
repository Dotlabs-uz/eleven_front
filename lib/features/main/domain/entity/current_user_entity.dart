import 'package:equatable/equatable.dart';

class CurrentUserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final int phoneNumber;
  final String avatar;
  final String password;
  final String login;
  final String role;

  const CurrentUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.phoneNumber,
    required this.password,
    required this.login,
    required this.role,
  });

  factory CurrentUserEntity.empty() {
    return const CurrentUserEntity(
      id: "",
      firstName: "",
      lastName: "",
      avatar: "",
      phoneNumber: 99,
      password: "",
      login: "",
      role: "managers",
    );
  }

  @override
  List<Object?> get props => [id];
}
