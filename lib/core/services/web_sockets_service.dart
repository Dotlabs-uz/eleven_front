import 'dart:async';

import 'package:eleven_crm/core/api/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketsService {

  final String url;
  WebSocketsService(this.url);


     final _socketResponse = StreamController<dynamic>();
  static IO.Socket? socket;

  void _addData(dynamic data) => _socketResponse.sink.add(data);
  void addDataToSocket(dynamic data) {
    debugPrint("Add data to socket $data");

     socket!.emit("create" ,data);



  }
  void sendData(String method,  dynamic data) {
    debugPrint("Send data $method $data");

     socket!.emit(method ,data);



  }
  void deleteFromSocket(dynamic data) {

    debugPrint("Delete from socket $data");
    socket!.emit("delete" ,data);
  }

  void addFilter(dynamic filter) {
    if (socket == null) {
      return;
    }

    debugPrint("Add filter $filter");

    // socket!.onack({"filter": filter});
    socket!.emit("getAll" ,filter);
  }

  Stream<dynamic> get getResponse => _socketResponse.stream;

  void dispose() {
    socket = null;
    _socketResponse.stream.drain();
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
      _addData(data);
    });

    // getResponse.map((event) => print(event));

    // await for (var data in getResponse) {
    //   yield data;
    // }

    return getResponse;
  }
}
