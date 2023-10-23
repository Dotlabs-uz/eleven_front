// ignore_for_file: unused_import

import '../../../../core/api/api_constants.dart';

class RequestTokenModel {
  final String login;
  final String password;
  final String role;

  RequestTokenModel({
    required this.login,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
    'role': role,
  };
}
