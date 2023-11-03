import 'dart:async';

import 'package:eleven_crm/core/api/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketsService {
  final String url;
  WebSocketsService(this.url);

  static final _socketResponse = StreamController<dynamic>();
  static IO.Socket? socket;

  void addData(dynamic data) => _socketResponse.sink.add(data);

  void addFilter(dynamic filter) {
    if (socket == null) {
      return;
    }

    // debugPrint("Add filter $filter");

    // socket!.onack({"filter": filter});
    socket!.emit("getAll" ,filter);
  }

  Stream<dynamic> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }

  Stream<dynamic> connect()  {
    IO.Socket localSoket =
        IO.io(url, OptionBuilder().setTransports(['websocket']).build());

    socket = localSoket;
    // print("Socket url $url");

    localSoket.onConnect((_) {
      // print("websocket connected");
    });

    localSoket.emit("getAll");

    localSoket.on('fetched', (data) {
      addData(data);
    });

    // getResponse.map((event) => print(event));

    // await for (var data in getResponse) {
    //   yield data;
    // }

    return getResponse;
  }
}
