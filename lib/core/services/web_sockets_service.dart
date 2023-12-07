import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:eleven_crm/core/api/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketsService {
  final String url;
  WebSocketsService(this.url);

  final _socketOrderResponse = StreamController<dynamic>();
  final _socketDatesResponse = StreamController<dynamic>();
  static IO.Socket? socket;

  void _addOrderData(dynamic data) => _socketOrderResponse.sink.add(data);
  void _addDatesData(dynamic data) => _socketDatesResponse.sink.add(data);
  void addDataToSocket(dynamic data) {
    debugPrint("Add data to socket $data");

    socket!.emit("create", data);
  }


  void refresh() {
    if (socket == null) return;

    socket!.emit("getAll");
  }

  void sendData(String method, dynamic data) {
    debugPrint("Send data $method $data");

    socket!.emit(method, data);
  }

  void deleteFromSocket(dynamic data) {
    debugPrint("Delete from socket $data");
    socket!.emit("delete", data);
  }

  void addFilter(dynamic filter) {
    if (socket == null) {
      return;
    }

    debugPrint("Add filter $filter");

    // socket!.onack({"filter": filter});
    socket!.emit("getAll", filter);
  }

  Stream<dynamic> get getOrderResponse => _socketOrderResponse.stream;
  Stream<dynamic> get getDatesResponse => _socketDatesResponse.stream;

  void dispose() {
    socket = null;
    _socketOrderResponse.close();
  }

  Stream<dynamic> connect(String token ) {



    IO.Socket localSoket =
        IO.io(url, OptionBuilder().setTransports(['websocket']).build());

    socket = localSoket;
    // print("Socket url $url");

    localSoket.onConnect((_) {
      // print("websocket connected");
    });
    localSoket.emit("join", {"token" : token});
    localSoket.emit("newDates");

    localSoket.emit("getAll");

    localSoket.on('fetched', (data) {
      // debugPrint("Orders $data");

      _addOrderData(data);
    });


    localSoket.on('datesWithIsNew', (data) {
      // debugPrint("Dates with is new $data");
      _addDatesData(data);
    });
    // getResponse.map((event) => print(event));

    // await for (var data in getResponse) {
    //   yield data;
    // }

    return getOrderResponse;
  }
  Stream<dynamic> connectDates() {
    IO.Socket localSoket =
        IO.io(url, OptionBuilder().setTransports(['websocket']).build());

    socket = localSoket;
    // print("Socket url $url");

    localSoket.onConnect((_) {
      // print("websocket connected");
    });
    localSoket.emit("getDates");


    localSoket.on('datesWithIsNew', (data) {
      _addDatesData(data);
    });
    return getOrderResponse;
  }
}
