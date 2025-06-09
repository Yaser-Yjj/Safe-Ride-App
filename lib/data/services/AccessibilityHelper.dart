import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccessibilityHelper {
  static const platform = MethodChannel('com.safe_ride_app.accessibility');

  static Future<bool> isAccessibilityServiceEnabled() async {
    try {
      final bool isEnabled = await platform.invokeMethod('isAccessibilityEnabled');
      return isEnabled;
    } on PlatformException catch (e) {
      debugPrint("❌ Failed to check accessibility: ${e.message}");
      return false;
    }
  }
}
