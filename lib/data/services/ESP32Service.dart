import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:safe_ride_app/data/services/auth_service.dart';
import 'package:safe_ride_app/data/services/emergency_call_handler.dart';
import 'package:safe_ride_app/data/services/emergency_sms_handler.dart';


class ESP32Service {
  static final ESP32Service _instance = ESP32Service._internal();
  factory ESP32Service() => _instance;
  ESP32Service._internal();

  Socket? socket;
  bool connected = false;

  bool autoReconnect = true;
  int reconnectAttempts = 0;
  final int maxReconnectAttempts = 1;
  final Duration reconnectDelay = const Duration(seconds: 5);

  final ip = "192.168.4.1";
  final port = 3333;

  final StreamController<String> _messageController =
      StreamController.broadcast();
  final StreamController<void> _accidentController =
      StreamController<void>.broadcast();

  Stream<String> get messages => _messageController.stream;
  Stream<void> get onAccident => _accidentController.stream;

  Future<void> connect(String ip, int port) async {
    if (connected) return;

    try {
      socket = await Socket.connect(ip, port);
      connected = true;

      socket!.listen(
        (data) async {
          String message = String.fromCharCodes(data).trim();
          _messageController.add(message);

          debugPrint("[ESP32] Received raw data: $message");

          if (message == "accident") {
            _accidentController.add(null);
            await handleEmergencySMS();
            await handleEmergencyCall(ip, port);
          }
        }, 
        onDone: () {
          connected = false;
          socket = null;
          _messageController.add('disconnected');
          startAutoReconnect(ip, port);
        },
        onError: (error) {
          connected = false;
          socket = null;
          _messageController.add('error: $error');
        },
      );
    } catch (e) {
      connected = false;
      socket = null;
      _messageController.add('connection_error: $e');
      rethrow;
    }
  }

  void startAutoReconnect(String ip, int port) {
    if (!connected && autoReconnect) {
      Future.delayed(reconnectDelay, () async {
        debugPrint("🔄 Attempting to reconnect to ESP32...");
        try {
          await connect(ip, port);
          debugPrint("✅ Reconnected to ESP32");
          reconnectAttempts = 0;
        } catch (_) {
          if (reconnectAttempts < maxReconnectAttempts) {
            reconnectAttempts++;
            debugPrint("❌ Reconnect attempt $reconnectAttempts failed");
            startAutoReconnect(ip, port);
          } else {
            debugPrint("🛑 Max reconnect attempts reached → Signing out");
            ESP32Service().disconnect();
            handleSignOut();
          }
        }
      });
    }
  }

  Future<void> sendMessage(String message) async {
    if (socket != null && connected) {
      socket!.write('$message\n');
      await socket!.flush();
    } else {
      throw Exception("Not connected to ESP32");
    }
  }

  void disconnect() {
    socket?.destroy();
    socket = null;
    connected = false;
    reconnectAttempts = 0;
    _messageController.add('disconnected');
  }

  void dispose() {
    _messageController.close();
    _accidentController.close();
  }
}

