import 'dart:async';
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_ride_app/data/services/AccessibilityHelper.dart';
import 'package:url_launcher/url_launcher.dart';

class ESP32Service {
  static final ESP32Service _instance = ESP32Service._internal();
  factory ESP32Service() => _instance;
  ESP32Service._internal();

  Socket? socket;
  bool connected = false;

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
            await _handleEmergencyCall();
          }
        },
        onDone: () {
          connected = false;
          socket = null;
          _messageController.add('disconnected');
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
    _messageController.add('disconnected');
  }

  void dispose() {
    _messageController.close();
    _accidentController.close();
  }
}

Future<void> _handleEmergencyCall() async {
  const String emergencyNumber = "0639114924";
  final Uri url = Uri(scheme: 'tel', path: '+212$emergencyNumber');

  debugPrint("🚨 Emergency requested: $url");

  if (kIsWeb) {
    if (await canLaunchUrl(url)) await launchUrl(url);
    return;
  }

  if (Platform.isAndroid) {
    final status = await Permission.phone.status;

    if (status.isGranted) {
      _openDialerWithIntent(emergencyNumber);
    } else {
      final result = await Permission.phone.request();

      if (result.isGranted) {
        _openDialerWithIntent(emergencyNumber);
      } else {
        debugPrint("_showPermissionDeniedDialog()");
      }
    }
  } else if (Platform.isIOS) {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  } else {
    debugPrint("⚠️ Platform not supported for calling");
  }
}

void _openDialerWithIntent(String number) async {
  try {
    final AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.CALL', 
      data: 'tel:$number',
    );
    await intent.launch();
  } catch (e) {
    debugPrint("❌ Failed to open dialer: $e");
  }
}

void checkAndOpenAccessibility() async {
  bool isEnabled = await AccessibilityHelper.isAccessibilityServiceEnabled();

  if (!isEnabled) {
    _openAccessibilitySettings();
  } else {
    debugPrint("✅ Accessibility already enabled.");
  }
}

void _openAccessibilitySettings() async {
  final AndroidIntent intent = AndroidIntent(
    action: 'android.settings.ACCESSIBILITY_SETTINGS',
  );
  await intent.launch();
}
