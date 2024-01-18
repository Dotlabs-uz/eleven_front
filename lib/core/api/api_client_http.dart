// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../../features/auth/data/datasources/authentication_local_data_source.dart';
import 'api_constants.dart';

abstract class ApiClientHttp {
  Future<dynamic> postPhoto({
    required List<int> fileBytes,
    required String userId,
    required String role,
  });
}

class ApiClientHttpImpl extends ApiClientHttp {
  final AuthenticationLocalDataSource _authenticationLocalDataSource;
  final Client _client;

  ApiClientHttpImpl(
    this._client,
    this._authenticationLocalDataSource,
  );

  @override
  Future<dynamic> postPhoto({
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

    var request = MultipartRequest(
      'POST',
      Uri.parse(
        "${ApiConstants.baseApiUrl}${ApiConstants.uploads}",
      ),
    );

    final avatar = MultipartFile.fromBytes(
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
}
