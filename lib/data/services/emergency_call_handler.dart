import 'dart:async';
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:safe_ride_app/data/services/ESP32Service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';


Future<void> handleEmergencyCall(String ip, int port) async {
  const String emergencyNumber = "0778961288";
  final Uri url = Uri(scheme: 'tel', path: '+212$emergencyNumber');

  debugPrint("🚨 Emergency requested: $url");

  if (kIsWeb) {
    if (await canLaunchUrl(url)) await launchUrl(url);
    return;
  }

  final espService = ESP32Service();

  if (Platform.isAndroid) {
    final status = await Permission.phone.status;

    if (status.isGranted) {
      _directCall(emergencyNumber);
      espService.startAutoReconnect(ip, port);
    } else {
      final result = await Permission.phone.request();

      if (result.isGranted) {
        _directCall(emergencyNumber);
        espService.startAutoReconnect(ip, port);
      }
    }
  } else if (Platform.isIOS) {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
    espService.startAutoReconnect(ip, port);
  } else {
    debugPrint("⚠️ Platform not supported for calling");
    espService.startAutoReconnect(ip, port);
  }
}

void _directCall(String number) async {
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