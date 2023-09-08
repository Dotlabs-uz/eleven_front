// ignore_for_file: unused_import

import '../../../../core/api/api_constants.dart';

class LoginRequestParams {
  final String phoneNumber;
  final String code;

  LoginRequestParams({
    required this.phoneNumber,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
        // 'phone': phoneNumber,
        'code': code,
      };
}
