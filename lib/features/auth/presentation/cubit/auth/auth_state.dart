part of 'auth_cubit.dart';

abstract class AuthState {}

class UserIsLoggedIn extends AuthState {}

class AuthLoadingState extends AuthState {}

class UserIsNotLoggedIn extends AuthState {}
class UserIsInWaiting extends AuthState {}
