import 'dart:async';

import 'package:eleven_crm/core/api/api_constants.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketsService {
  WebSocketsService();

  final _socketResponse = StreamController<dynamic>();

  void addData(dynamic data) => _socketResponse.sink.add(data);

  Stream<dynamic> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }

  Stream<dynamic> connect(String url) async* {
    IO.Socket socket =
        IO.io(url, OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) {
      print("websocket connected $_");
    });

    socket.on('event', (data) => addData(data));

    await for (var data in getResponse) {
      yield data;
    }
  }
}
