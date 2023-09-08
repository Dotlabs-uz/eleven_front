// ignore_for_file: unused_import

import '../../../../core/api/api_constants.dart';

class RequestTokenModel {
  final String phoneNumber;
  final String code;

  RequestTokenModel({
    required this.phoneNumber,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
    // 'phone': phoneNumber,
    'code': code,
  };
}
