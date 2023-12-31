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
  Future<bool> saveCurrentUser(CurrentUserModel model);
  Future<bool> saveOrder(OrderModel model);
  Future<bool> savePhoto(List<int> file, String userId, String role);
  Future<bool> deleteOrder(String orderId);
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

    final model = CurrentUserModel.fromJson(response);

    return model;
  }

  @override
  Future<bool> saveCurrentUser(CurrentUserModel model) async {
    await _client.patch("${ApiConstants.managers}/${model.id}",
        params: model.toJson());

    return true;
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
    final map = {
      "from": from.toIso8601String(),
      "to": to.toIso8601String(),
      "employee": employeeId,
    };

    debugPrint("map data $map");
    await _client.post(
      ApiConstants.notWorkingHours,
      params: map,
    );
    return true;
  }

  @override
  Future<bool> saveOrder(OrderModel model) async {
    debugPrint("Order model id ${model.id}");
    if (model.id.isEmpty) {
      await _client.post(ApiConstants.orders, params: model.toJson());
    } else {
      await _client.patch("${ApiConstants.orders}/${model.id}/",
          params: model.toJson());
    }
    return true;
  }

  @override
  Future<bool> deleteOrder(String orderId) async {
    await _client.deleteWithBody(
      "${ApiConstants.orders}/$orderId",
    );

    return true;
  }

  @override
  Future<bool> savePhoto(List<int> file, String userId, String role) async {
    debugPrint("User id $userId  role $role ")
;    await _client.postPhoto(fileBytes: file, userId: userId, role: role);

    return true;
  }
}
