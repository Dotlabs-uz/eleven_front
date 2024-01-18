// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';

import '../../features/auth/data/datasources/authentication_local_data_source.dart';
import 'api_constants.dart';
import 'api_exceptions.dart';

abstract class ApiClient {
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? params,
    Map<dynamic, dynamic>? filter,
  });
  Future<dynamic> post(
    String path, {
    required Map<String, dynamic> params,
    bool withToken = false,
  });
  Future<dynamic> patch(
    String path, {
    required Map<String, dynamic> params,
  });
  Future<dynamic> deleteWithBody(String path);
}

class ApiClientImpl extends ApiClient {
  final AuthenticationLocalDataSource _authenticationLocalDataSource;
  final Dio clientDio;

  ApiClientImpl(
    this.clientDio,
    this._authenticationLocalDataSource,
  );

  @override
  Future<dynamic> get(
    String path, {
    Map<dynamic, dynamic>? filter,
    Map<String, dynamic>? params,
  }) async {
    String sessionId =
        await _authenticationLocalDataSource.getSessionId() ?? "";

    var paramsString = '';
    if (filter?.isNotEmpty ?? false) {
      filter?.forEach((key, value) {
        paramsString += '&$key=$value';
      });
    }

    final pth = '${ApiConstants.baseApiUrl}$path$paramsString';

    debugPrint("Pth $pth");

    final header = {
      'Authorization': sessionId,
    };

    final response = await clientDio.get(
      pth, //?format=json
      options: buildCacheOptions(
        const Duration(
          days: 1,
        ),
        forceRefresh: false,
        maxStale: const Duration(days: 7),
        options: Options(contentType: "application/json", headers: header),
      ),
    );

    return _errorHandler(response);
  }

  @override
  Future patch(String path, {Map<dynamic, dynamic>? params}) async {
    String sessionId =
        await _authenticationLocalDataSource.getSessionId() ?? "";
    Map<String, String> header = {
      'Accept': 'application/json',
    };

    if (sessionId != '') {
      header.addAll({'Authorization': sessionId});
    }

    final pth = getPath(path);
    debugPrint("Path $pth");
    final response = await clientDio.patch(
      pth,
      data: jsonEncode(params),
      options: Options(headers: header),
    );
    if (kDebugMode) {
      debugPrint(response.data);
    }

    debugPrint("Response $path ${response.statusCode}");
    return _errorHandler(response);
  }

  @override
  Future<dynamic> deleteWithBody(String path) async {
    String sessionId =
        (await _authenticationLocalDataSource.getSessionId()) ?? "";
    final header = {'Authorization': sessionId};

    final response = await clientDio.delete(
      getPath(path),
      options: Options(headers: header),
    );

    debugPrint("API delete response code: ${response.statusCode} ");
    return _errorHandler(response);
  }

  @override
  Future post(String path,
      {required Map<String, dynamic> params, bool withToken = false}) async {
    String sessionId =
        await _authenticationLocalDataSource.getSessionId() ?? "";
    Map<String, String> header = {
      "Content-type": "application/json",
      "Accept": "*/*"
    };
    if (kDebugMode) {
      debugPrintThrottled("Request params: $params ");
    }
    if (sessionId != '') {
      header.addAll({
        'Authorization': ' $sessionId',
      });
    }

    final uri = Uri.parse(ApiConstants.baseApiUrl + path);

    log("Post uri = $uri");
    log("Post header = $header");

    debugPrint("Post body =  ${jsonEncode(params)}");
    final response = await clientDio.post(
      getPath(path),
      data: jsonEncode(params),
      options: Options(headers: header,),
    );
    if (kDebugMode) {
      debugPrint("API post response: ${response.statusCode} ");
      debugPrint(response.data.toString());
    }

    debugPrint("Response status ${response.statusCode}");
    return _errorHandler(response);
  }

  _errorHandler(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else if (response.statusCode == 400 ||
        response.statusCode == 403 ||
        response.statusCode == 401 ||
        response.statusCode == 405 ||
        response.statusCode == 500 ||
        response.statusCode == 409) {
      String msg = "unknown_error";
      var resp = jsonDecode(response.data);

      if (resp.containsKey("error")) {
        msg = resp["error"];
      } else if (resp.containsKey("message")) {
        var rsp = resp["message"];
        if (rsp.runtimeType == String) msg = resp["message"];
        if (rsp.runtimeType == List) msg = rsp[0];
      } else {
        msg = utf8
            .decode(response.data)
            .replaceAll("[", '')
            .replaceAll("]", '')
            .replaceAll("}", '')
            .replaceAll("{", '')
            .replaceAll("\\", '');
      }
      throw ExceptionWithMessage(msg);
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else {
      throw Exception(response.statusMessage);
    }
  }

  String getPath(String path, {Map<dynamic, dynamic>? params}) {
    var paramsString = '';
    if (params?.isNotEmpty ?? false) {
      params?.forEach((key, value) {
        paramsString += '&$key=$value';
      });
    }

    return '${ApiConstants.baseApiUrl}$path$paramsString';
  }
}
