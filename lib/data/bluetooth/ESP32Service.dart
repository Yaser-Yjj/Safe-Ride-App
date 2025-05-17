import 'dart:io';

import 'package:flutter/material.dart';

class ESP32Service {
  static final ESP32Service _instance = ESP32Service._internal();

  factory ESP32Service() => _instance;

  ESP32Service._internal();

  Socket? socket;
  bool connected = false;

  Future<void> connect(String ip, int port) async {
    try {
      socket = await Socket.connect(ip, port);
      debugPrint("Connected to ESP32 at $ip:$port");
      connected = true;
    } catch (e) {
      debugPrint("Failed to connect: $e");
    }
  }

  Future<void> sendMessage(String message) async {
    if (socket != null && connected) {
      try {
        socket!.write(message);
        debugPrint("Sent: $message");
      } catch (e) {
        debugPrint("Error writing to socket: $e");
      }
    } else {
      debugPrint("Not connected to ESP32");
    }
  }

  void closeConnection() {
    socket?.destroy();
    socket = null;
    connected = false;
  }
}
