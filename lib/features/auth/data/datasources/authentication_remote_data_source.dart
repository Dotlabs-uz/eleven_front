import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../models/request_token_model.dart';
import '../models/token_model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<TokenModel> validateWithLogin(RequestTokenModel requestBody);
  Future<bool> deleteUser({required String smsCode, required String token});

  Future<bool> changePassword({
    // required String userId,
    // required String userName,
    required String newPassword,
  });
}

class AuthenticationRemoteDataSourceImpl
    extends AuthenticationRemoteDataSource {
  final ApiClient _client;

  AuthenticationRemoteDataSourceImpl(this._client);

  @override
  Future<TokenModel> validateWithLogin(
    RequestTokenModel requestBody,
  ) async {
    final response = await _client.post(
      ApiConstants.signIn ,
      withToken: false,
      params: requestBody.toJson(),
    );

    log(response.toString(), name: "Token");

    debugPrint("Validate login");

    return TokenModel.fromJson(response);
  }


  @override
  Future<bool> changePassword({
    required String newPassword,
  }) async {
    return false;
    // final json = await _client.postWidthSQL(ApiConstants.sql, body);
    //
    // final dataList = List.from(json[0]['result']);
    // if (dataList.isEmpty) {
    //   return false;
    // }
    //
    // return true;
  }

  @override
  Future<bool> deleteUser({required String smsCode, required String token}) async {

    return true;
  }

}
