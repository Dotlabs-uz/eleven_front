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

    log("Pth $pth");


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

  dynamic postPhoto(String path, {required String filename}) async {
    String? sessionId = await _authenticationLocalDataSource.getSessionId();

    log("File name $filename");

    var headers = {
      'Content-Type': 'application/json',
    };

    log("Basic $sessionId");
    if (sessionId != '') {
      debugPrint("Token $sessionId");

      headers.addAll({'Authorization': '$sessionId'});
    }

    debugPrint("filename $filename");
    var request = http.MultipartRequest(
        'PUT', Uri.parse('${ApiConstants.baseApiUrl}$path'));
    request.files.add(await http.MultipartFile.fromPath(
      'avatar',
      filename,
    ));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    debugPrint("Status ${response.statusCode}");
    if (response.statusCode == 200) {
      debugPrint(await response.stream.bytesToString());
      return true;
    } else {
      debugPrint(response.reasonPhrase);
      return false;
    }

    // if (sessionId != '')
    //   headers.addAll({'Authorization': 'Basic YWRtaW46YWRtaW4='});

    // MultipartRequest request = http.MultipartRequest(
    //   'PUT',
    //   Uri.parse('${ApiConstants.baseApiUrl}$path'),
    // );
    // log("Zapros nachalo ${Uri.parse('${ApiConstants.baseApiUrl}$path')}");
    //
    // log("Request $request");
    //
    // request.files.add(await http.MultipartFile.fromPath("avatar", filename));
    //
    // request.headers.addAll(headers);
    //
    // log("Request: ${request}");
    //
    // http.StreamedResponse response = await request.send();
    //
    // log("REsponse status code: ${response.statusCode}");
    //
    // log(response.statusCode.toString());
    //
    // log(await response.stream.bytesToString());
    //
    // if (response.statusCode == 200) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  dynamic post(String path,
      {Map<dynamic, dynamic>? params, bool withToken = true,}) async {
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
    log("Post body =  ${jsonEncode(params)}");
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
        response.statusCode == 500) {
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

    final pth =  getPath(path, null);
    print("Path $pth");
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
