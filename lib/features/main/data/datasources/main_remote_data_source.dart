// ignore_for_file: unused_import

import 'dart:developer';

import 'package:eleven_crm/features/main/data/model/current_user_model.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../auth/data/models/token_model.dart';
import '../model/order_model.dart';

abstract class MainRemoteDataSource {
  Future<CurrentUserModel> getCurrentUser();
  Future<bool> saveNotWorkingHours(
      DateTime from, DateTime to, String employeeId);
  Future<List<OrderModel>> getOrders();
}

class MainRemoteDataSourceImpl extends MainRemoteDataSource {
  final ApiClient _client;

  MainRemoteDataSourceImpl(this._client);

  @override
  Future<CurrentUserModel> getCurrentUser() async {
    final response = await _client.get(ApiConstants.getCurrentUser);

    print("Response $response");
    final model = CurrentUserModel.fromJson(response['results'][0]);

    return const CurrentUserModel(
      id: "id",
      firstName: "firstName",
      lastName: "lastName",
      phoneNumber: "phoneNumber",
      password: "password",
      login: "login",
      role: "role",
    );
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    // TODO: implement getOrders
    throw UnimplementedError();
  }

  @override
  Future<bool> saveNotWorkingHours(
      DateTime from, DateTime to, String employeeId) async {
    log("From ${from.toIso8601String()} to ${to.toIso8601String()}");
    await _client.post(ApiConstants.notWorkingHours, params: {
      "from": from.toIso8601String(),
      "to": to.toIso8601String(),
      "employee": employeeId,
    }

        // TODO employee changed
        );
    return true;
  }
}
