import 'dart:developer';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketServices {
  static final SocketServices _singleton = SocketServices._internal();

  factory SocketServices() {
    return _singleton;
  }

  SocketServices._internal();

  // String socketUrlTest = '192.168.1.209:9090';
  // String socketUrl = 'ws://139.99.171.195:9099';

  WebSocketChannel _channel = IOWebSocketChannel.connect(
    'ws://139.99.171.195:9099/websocket',
  );
  WebSocketChannel get socketChannel => _channel;
  void closeSocket() {
    _channel.sink.close();
  }
}
