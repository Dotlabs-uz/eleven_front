import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../../features/auth/data/datasources/authentication_local_data_source.dart';
import 'api_constants.dart';
import 'api_exceptions.dart';

class ApiClient {
  final AuthenticationLocalDataSource _authenticationLocalDataSource;
  final Client _client;

  ApiClient(this._client, this._authenticationLocalDataSource);

  dynamic get(String path,
      {Map<dynamic, dynamic>? filter,
      bool parse = true,
      Map<String, dynamic>? params}) async {
    String sessionId =
        await _authenticationLocalDataSource.getSessionId() ?? "";

    var paramsString = '';
    if (filter?.isNotEmpty ?? false) {
      filter?.forEach((key, value) {
        paramsString += '&$key=$value';
      });
    }

    final pth =
        Uri.parse('${ApiConstants.baseApiUrl}$path$paramsString').replace(
      queryParameters: params,
    );

    debugPrint("Pth $pth");

    final header = {
      'Authorization': sessionId,
      'Content-Type': 'application/json',
    };

    final response = await _client.get(
      pth, //?format=json
      headers: header,
    );

    // log("Token $sessionId path: ${pth}  header $header Status code: ${response.statusCode}");
    // debugPrint("Get balance $pth status code ${response.statusCode} body ${response.body}");

    if (response.statusCode == 200) {
      if (parse) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
      return response.body;
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      String msg = "unknown_error";
      var resp = jsonDecode(utf8.decode(response.bodyBytes));
      if (resp.containsKey("error")) {
        msg = resp["error"];
      } else if (resp.containsKey("message")) {
        var rsp = resp["message"];
        if (rsp.runtimeType == String) msg = resp["message"];
        if (rsp.runtimeType == List) msg = rsp[0];
      } else {
        msg = utf8
            .decode(response.bodyBytes)
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
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic postPhoto({
    required List<int> fileBytes,
    required String userId,
    required String role,
  }) async {
    String? sessionId = await _authenticationLocalDataSource.getSessionId();

    var headers = {
      'Content-Type': 'multipart/form-data',
    };

    if (sessionId != '') {
      headers.addAll({'Authorization': '$sessionId'});
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        "${ApiConstants.baseApiUrl}${ApiConstants.uploads}",
      ),
    );

    final avatar = http.MultipartFile.fromBytes(
      'avatar',
      fileBytes,
      filename: 'avatar.png',
    );
    // Добавляем файл в запрос
    request.files.add(
      avatar,
    );

    // Добавляем параметры в тело запроса
    // request.fields['avatar'] = avatar;
    request.fields['userId'] = userId;
    request.fields['path'] = role;

    request.headers.addAll(headers);

    try {
      final response = await request.send();

      debugPrint("message ${response.request}");
      debugPrint("Status ${response.statusCode}");

      if (response.statusCode == 200) {
        debugPrint(await response.stream.bytesToString());
        return true;
      } else {
        debugPrint(response.reasonPhrase);
        return false;
      }
    } catch (error) {
      debugPrint("Error: $error");
      return false;
    }
  }

  dynamic post(
    String path, {
    Map<dynamic, dynamic>? params,
    bool withToken = true,
  }) async {
    String sessionId =
        await _authenticationLocalDataSource.getSessionId() ?? "";
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "*/*"
    };
    if (kDebugMode) {
      debugPrintThrottled("Request params: $params ");
    }
    if (sessionId != '' && withToken) {
      log("Session != null $sessionId");
      userHeader.addAll({
        'Authorization': ' $sessionId',
      });
    }

    final uri = Uri.parse(ApiConstants.baseApiUrl + path);

    log("Post uri = $uri");
    log("Post header = $userHeader");
    debugPrint("Post body =  ${jsonEncode(params)}");
    final response = await _client.post(
      uri,
      body: jsonEncode(params),
      headers: userHeader,
    );
    if (kDebugMode) {
      debugPrint("API post response: ${response.statusCode} ");
      debugPrint(utf8.decode(response.bodyBytes));
    }

    debugPrint("Response status ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      // debugPrint("Everyt thing ok");
      return json.decode(utf8.decode(response.bodyBytes));
    }
    if (response.statusCode == 400 ||
        response.statusCode == 403 ||
        response.statusCode == 405 ||
        response.statusCode == 500 || response.statusCode == 409) {
      String msg = "unknown_error";
      var resp = jsonDecode(utf8.decode(response.bodyBytes));
      if (resp.containsKey("error")) {
        msg = resp["error"];
      } else if (resp.containsKey("message")) {
        var rsp = resp["message"];
        if (rsp.runtimeType == String) msg = resp["message"];
        if (rsp.runtimeType == List) msg = rsp[0];
      } else {
        msg = utf8
            .decode(response.bodyBytes)
            .replaceAll("[", '')
            .replaceAll("]", '')
            .replaceAll("}", '')
            .replaceAll("{", '')
            .replaceAll("\\", '');
      }
      throw ExceptionWithMessage(msg);
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else if (response.statusCode == 404) {
      throw const ExceptionWithMessage("Not found");
    } else {
      debugPrint("Exception ${response.reasonPhrase}");
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic patch(String path, {Map<dynamic, dynamic>? params}) async {
    String sessionId =
        await _authenticationLocalDataSource.getSessionId() ?? "";
    Map<String, String> userHeader = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (sessionId != '') {
      userHeader.addAll({'Authorization': sessionId});
    }

    final pth = getPath(path, null);
    debugPrint("Path $pth");
    final response = await _client.patch(
      pth,
      body: jsonEncode(params),
      headers: userHeader,
    );
    if (kDebugMode) {
      debugPrint(utf8.decode(response.bodyBytes));
    }

    debugPrint("Response $path ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      // debugPrint("Everyt thing ok");
      return json.decode(utf8.decode(response.bodyBytes));
    }
    if (response.statusCode == 400 ||
        response.statusCode == 403 ||
        response.statusCode == 405) {
      String msg = "unknown_error";
      var resp = jsonDecode(utf8.decode(response.bodyBytes));
      if (resp.containsKey("error")) {
        msg = resp["error"];
      } else if (resp.containsKey("message")) {
        var rsp = resp["message"];
        if (rsp.runtimeType == String) msg = resp["message"];
        if (rsp.runtimeType == List) msg = rsp[0];
      } else {
        msg = utf8
            .decode(response.bodyBytes)
            .replaceAll("[", '')
            .replaceAll("]", '')
            .replaceAll("}", '')
            .replaceAll("{", '')
            .replaceAll("\\", '');
      }
      throw ExceptionWithMessage(msg);
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else if (response.statusCode == 404) {
      throw const ExceptionWithMessage("Not found");
    } else {
      debugPrint("Exception ${response.reasonPhrase}");
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic deleteWithBody(String path, {Map<dynamic, dynamic>? params}) async {
    String sessionId =
        (await _authenticationLocalDataSource.getSessionId()) ?? "";
    final response = await _client.delete(
      //getPath(path, null),
      Uri.parse('${ApiConstants.baseApiUrl}$path'),

      headers: {
        'Authorization': ' $sessionId',

        // 'Content-Type': 'application/json',
      },
    );

    debugPrint("API delete response code: ${response.statusCode} ");
    debugPrint(utf8.decode(response.bodyBytes));
    if (response.statusCode == 204) {
      return {'success': true};
    } else if (response.statusCode == 200) {
      return {'success': true};
    } else if (response.statusCode == 400 ||
        response.statusCode == 403 ||
        response.statusCode == 402 ||
        response.statusCode == 405) {
      String msg = "unknown_error";
      var resp = jsonDecode(utf8.decode(response.bodyBytes));
      if (resp.containsKey("error")) {
        msg = resp["error"];
      } else if (resp.containsKey("message")) {
        var rsp = resp["message"];
        if (rsp.runtimeType == String) msg = resp["message"];
        if (rsp.runtimeType == List) msg = rsp[0];
      } else {
        msg = utf8
            .decode(response.bodyBytes)
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
      throw Exception(response.reasonPhrase);
    }
  }

  Uri getPath(String path, Map<dynamic, dynamic>? params) {
    var paramsString = '';
    if (params?.isNotEmpty ?? false) {
      params?.forEach((key, value) {
        paramsString += '&$key=$value';
      });
    }

    return Uri.parse('${ApiConstants.baseApiUrl}$path$paramsString');
    // '${ApiConstants.BASE_URL}$path?api_key=${ApiConstants.API_KEY}$paramsString');
  }
}

// ================ DIO ================ //
//
// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:dio/dio.dart';
// import 'package:dio_http_cache/dio_http_cache.dart';
// import 'package:flutter/foundation.dart';
//
// import '../../features/auth/data/datasources/authentication_local_data_source.dart';
// import 'api_constants.dart';
// import 'api_exceptions.dart';
//
// class ApiClient {
//   final AuthenticationLocalDataSource _authenticationLocalDataSource;
//   final Dio _dio;
//
//   ApiClient(this._dio, this._authenticationLocalDataSource) {
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           // options.headers.addAll({
//           //   'Content-Type': 'application/json',
//           // });
//           return handler.next(options);
//         },
//       ),
//     );
//
//     _dio.interceptors.add(
//       DioCacheManager(CacheConfig(
//               baseUrl: ApiConstants.baseApiUrl,
//               defaultMaxAge: const Duration(days: 3),
//               defaultMaxStale: const Duration(days: 5)))
//           .interceptor,
//     );
//   }
//
//   Future<dynamic> get(String path,
//       {Map<dynamic, dynamic>? filter,
//       bool parse = true,
//       Map<String, dynamic>? params}) async {
//     try {
//       final sessionToken = await _authenticationLocalDataSource.getSessionId();
//       final header = {
//         'Authorization': sessionToken,
//         'Content-Type': 'application/json',
//       };
//       final response = await _dio.get(path,
//           // queryParameters: params,
//           options: Options(
//             headers: header,
//           ));
//
//       if (response.statusCode == 200) {
//         if (parse) {
//           return json.decode(response.data);
//         }
//         return response.data;
//       } else if (response.statusCode == 400 || response.statusCode == 404) {
//         throw const ExceptionWithMessage("Unknown error");
//       } else if (response.statusCode == 401) {
//         throw UnauthorisedException();
//       } else {
//         throw Exception(response.statusMessage);
//       }
//     } catch (error) {
//       throw Exception("Error: $error");
//     }
//   }
//
//   Future<dynamic> post(String path,
//       {Map<dynamic, dynamic>? params, bool withToken = true}) async {
//     try {
//       String sessionId =
//           await _authenticationLocalDataSource.getSessionId() ?? "";
//       Map<String, String> userHeader = {
//         "Content-type": "application/json",
//         "Accept": "*/*"
//       };
//
//           final uri = ApiConstants.baseApiUrl + path;
//
//       final response = await _dio.post(
//         uri,
//         options: Options(headers: userHeader),
//         data: jsonEncode(params),
//       );
//
//       if (sessionId != '' && withToken) {
//         log("Session != null $sessionId");
//         userHeader.addAll({
//           'Authorization': ' $sessionId',
//         });
//       }
//
//       debugPrint("API post response: ${response.statusCode} ");
//       debugPrint(utf8.decode(response.data));
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return json.decode(response.data.toString());
//       } else if (response.statusCode == 400 ||
//           response.statusCode == 403 ||
//           response.statusCode == 405 ||
//           response.statusCode == 500 ||
//           response.statusCode == 409) {
//         throw const ExceptionWithMessage("Unknown error");
//       } else if (response.statusCode == 401) {
//         throw UnauthorisedException();
//       } else if (response.statusCode == 404) {
//         throw const ExceptionWithMessage("Not found");
//       } else {
//         throw Exception(response.statusMessage);
//       }
//     } catch (error) {
//       throw Exception("Error: $error");
//     }
//   }
//
//   Future<dynamic> postPhoto({
//     required List<int> fileBytes,
//     required String userId,
//     required String role,
//   }) async {
//     try {
//       final sessionId = await _authenticationLocalDataSource.getSessionId();
//
//       var headers = {
//         'Content-Type': 'multipart/form-data',
//       };
//
//       if (sessionId != '') {
//         headers.addAll({'Authorization': '$sessionId'});
//       }
//
//       var request = FormData.fromMap({
//         'avatar': MultipartFile.fromBytes(
//           fileBytes,
//           filename: 'avatar.png',
//         ),
//         'userId': userId,
//         'path': role,
//       });
//
//       final response = await _dio.post(
//         "${ApiConstants.baseApiUrl}${ApiConstants.uploads}",
//         data: request,
//         options: Options(headers: headers),
//       );
//
//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         return false;
//       }
//     } catch (error) {
//       throw Exception("Error: $error");
//     }
//   }
//
//   // Добавьте другие методы, такие как patch, deleteWithBody, если они используются в вашем коде.
//
//   // ...
//
//   Future<dynamic> patch(String path, {Map<dynamic, dynamic>? params}) async {
//     try {
//       final sessionId = await _authenticationLocalDataSource.getSessionId();
//
//       var userHeader = {
//         'Content-Type': 'application/json',
//         'Accept': '*/*',
//       };
//
//       if (kDebugMode) {
//         debugPrintThrottled("Request params: $params ");
//       }
//
//       if (sessionId != '') {
//         userHeader.addAll({
//           'Authorization': ' $sessionId',
//         });
//       }
//
//       final response = await _dio.patch(
//         ApiConstants.baseApiUrl + path,
//         data: params,
//         options: Options(headers: userHeader),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return json.decode(response.toString());
//       } else if (response.statusCode == 400 ||
//           response.statusCode == 403 ||
//           response.statusCode == 405) {
//         throw const ExceptionWithMessage("Unknown error");
//       } else if (response.statusCode == 401) {
//         throw UnauthorisedException();
//       } else if (response.statusCode == 404) {
//         throw const ExceptionWithMessage("Not found");
//       } else {
//         throw Exception(response.statusMessage);
//       }
//     } catch (error) {
//       throw Exception("Error: $error");
//     }
//   }
//
//   Future<dynamic> deleteWithBody(String path,
//       {Map<dynamic, dynamic>? params}) async {
//     try {
//       final sessionId = await _authenticationLocalDataSource.getSessionId();
//
//       final response = await _dio.delete(
//         '${ApiConstants.baseApiUrl}$path',
//         data: params,
//         options: Options(
//           headers: {
//             'Authorization': ' $sessionId',
//           },
//         ),
//       );
//
//       if (response.statusCode == 204 || response.statusCode == 200) {
//         return {'success': true};
//       } else if (response.statusCode == 400 ||
//           response.statusCode == 403 ||
//           response.statusCode == 402 ||
//           response.statusCode == 405) {
//         throw const ExceptionWithMessage("Unknown error");
//       } else if (response.statusCode == 401) {
//         throw UnauthorisedException();
//       } else {
//         throw Exception(response.statusMessage);
//       }
//     } catch (error) {
//       throw Exception("Error: $error");
//     }
//   }
//
//   Uri getPath(String path, Map<dynamic, dynamic>? params) {
//     var paramsString = '';
//     if (params?.isNotEmpty ?? false) {
//       params?.forEach((key, value) {
//         paramsString += '&$key=$value';
//       });
//     }
//
//     return Uri.parse('${ApiConstants.baseApiUrl}$path$paramsString');
//   }
// }
