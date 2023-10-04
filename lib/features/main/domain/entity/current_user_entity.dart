import 'package:equatable/equatable.dart';

class CurrentUserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String password;
  final String login;
  final String role;

  const CurrentUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.password,
    required this.login,
    required this.role,
  });

  @override
  List<Object?> get props => [id];
}
