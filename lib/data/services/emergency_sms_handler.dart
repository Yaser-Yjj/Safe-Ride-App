import 'dart:async';
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> handleEmergencySMS() async {
  final prefs = await SharedPreferences.getInstance();
  final contactName = "Hamza";
  final contact1Number ="0632114924";
  final fullName = prefs.getString("full_name");

  final location = "https://maps.google.com/?q=33.9883702,-6.8574214";
  final time = DateTime.now().toIso8601String();

  final String smsMessageArabic = """
مرحبا $contactName،
بغي نعَلمك بلي $fullName راح تلاقا ب الحادث.
مكان ديالك هو هاد الرابط: $location
وقت الحادث: $time

دعم SafeRide
""";

  final Uri smsUri = Uri(
    scheme: 'sms',
    path: contact1Number,
    queryParameters: {'body': Uri.encodeComponent(smsMessageArabic)},
  );

  debugPrint("📲 SMS URI: $smsUri");

  if (kIsWeb) {
    if (await canLaunchUrl(smsUri)) await launchUrl(smsUri);
    return;
  }

  if (Platform.isAndroid) {
    final status = await Permission.sms.status;

    if (status.isGranted) {
      _directSms(contact1Number, smsMessageArabic);
    } else {
      final result = await Permission.sms.request();
      if (result.isGranted) {
        _directSms(contact1Number, smsMessageArabic);
      } else {
        debugPrint("❌ SMS permission denied");
        _showEnableSMSDialog(smsUri);
      }
    }
  } else if (Platform.isIOS) {
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      debugPrint("❌ Can't open Messages on iOS");
    }
  } else {
    debugPrint("⚠️ Platform not supported for SMS");
  }
}

void _directSms(String number, String message) async {
  try {
    final AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'smsto:$number',
      arguments: {
        'sms_body': message,
      },
    );
    await intent.launch();
    debugPrint("📲 SMS app opened with body");
  } catch (e) {
    debugPrint("❌ Failed to open SMS app: $e");
  }
}

void _showEnableSMSDialog(Uri smsUri) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final context = navigatorKey.currentState?.context;
    if (context != null && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.red.shade50,
          title: Text("⚠️ SMS Permission Required"),
          content: Text(
            "To send emergency alerts automatically, please allow SMS permission.",
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(context);
                openAppSettings();
              },
              child: Text("Go to Settings"),
            )
          ],
        ),
      );
    }
  });
}

