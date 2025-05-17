import 'dart:async';
import 'dart:convert';
import 'dart:io';

class ESP32Service {
  static final ESP32Service _instance = ESP32Service._internal();
  factory ESP32Service() => _instance;
  ESP32Service._internal();

  Socket? socket;
  bool connected = false;

  // ✅ Use Broadcast Stream to allow multiple listeners
  final StreamController<String> _controller =
      StreamController<String>.broadcast();
  Stream<String> get messages => _controller.stream;

  Future<void> connect(String ip, int port) async {
    if (connected) return;

    try {
      socket = await Socket.connect(ip, port);
      connected = true;

      socket!.listen(
        (data) {
          final msg = utf8.decode(data).trim();
          _controller.add(msg);
        },
        onDone: () {
          connected = false;
          socket = null;
          _controller.add('disconnected');
        },
        onError: (error) {
          connected = false;
          socket = null;
          _controller.add('error: $error');
        },
      );
    } catch (e) {
      connected = false;
      socket = null;
      _controller.add('error: $e');
      rethrow;
    }
  }

  Future<void> sendMessage(String message) async {
    if (socket != null && connected) {
      socket!.write('$message\n');
      await socket!.flush();
    } else {
      throw Exception('Not connected');
    }
  }

  void disconnect() {
    socket?.destroy();
    socket = null;
    connected = false;
    _controller.add('disconnected');
  }
}
