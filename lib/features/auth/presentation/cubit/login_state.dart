part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginSuccess extends LoginState {}

class TokenState extends LoginState {
  final String token;

  TokenState({required this.token});
}

class ChangePasswordError extends LoginState {
  final String message;

  ChangePasswordError(this.message);
}

class ChangePasswordSuccess extends LoginState {}

class LogoutSuccess extends LoginState {}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}

class SMSCodeIsNotCorrect extends LoginState {}
