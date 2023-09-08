// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../auth/data/models/token_model.dart';

abstract class MainRemoteDataSource {

  Future<bool> saveDriver();

}

class MainRemoteDataSourceImpl extends MainRemoteDataSource {
  final ApiClient _client;

  MainRemoteDataSourceImpl(this._client);

  @override
  Future<bool> saveDriver() async {
     return true;
  }

}
