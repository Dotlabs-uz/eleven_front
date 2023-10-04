// ignore_for_file: unused_import

import 'dart:developer';

import 'package:eleven_crm/features/main/data/model/current_user_model.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../auth/data/models/token_model.dart';

abstract class MainRemoteDataSource {

  Future<CurrentUserModel>getCurrentUser();

}

class MainRemoteDataSourceImpl extends MainRemoteDataSource {
  final ApiClient _client;

  MainRemoteDataSourceImpl(this._client);

  @override
  Future<CurrentUserModel> getCurrentUser() async {
    final response = await _client.get(ApiConstants.getCurrentUser);

    print("Response $response");
    final model = CurrentUserModel.fromJson(response['results'][0]);

    return CurrentUserModel(id: "id", firstName: "firstName", lastName: "lastName", phoneNumber: "phoneNumber", password: "password", login: "login", role: "role");
  }

}
