import 'dart:async';

import 'package:eleven_crm/core/api/api_constants.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketsService {

  WebSocketsService() {
    initialize();
  }
  final _socketResponse = StreamController<dynamic>();



  void Function(dynamic) get addResponse => _socketResponse.sink.add;

  Stream<dynamic> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }

  initialize() {
    IO.Socket socket = IO.io(ApiConstants.ordersWebSocket,
        OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) {});

    socket.on('event', (data) => addResponse);
  }
}
