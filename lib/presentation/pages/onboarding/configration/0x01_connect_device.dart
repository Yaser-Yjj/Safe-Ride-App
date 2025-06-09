import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';
import 'package:safe_ride_app/data/services/ESP32Service.dart';
import 'package:safe_ride_app/presentation/routes/app_routes.dart';
import 'package:safe_ride_app/presentation/widgets/home/connection_dialog.dart';
import 'package:safe_ride_app/presentation/widgets/main/app_bar.dart';
import 'package:safe_ride_app/presentation/widgets/splash/custome_snackbar.dart';
import 'package:safe_ride_app/presentation/widgets/splash/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ESP32Controller extends StatefulWidget {
  const ESP32Controller({super.key});

  @override
  State<ESP32Controller> createState() => _ESP32ControllerState();
}

class _ESP32ControllerState extends State<ESP32Controller> {
  final ip = "192.168.4.1";
  final port = 3333;
  String response = "No response yet";
  late final ESP32Service espService;
  StreamSubscription<String>? subscription;

  @override
  void initState() {
    super.initState();
    espService = ESP32Service();
    bool initialized = false;
    if (!initialized) {
      checkAndOpenAccessibility();
      initialized = true;
    }
  }

  Future<void> connectToESP32() async {
    try {
      await espService.connect(ip, port);
      if (espService.connected) {
        setState(() {
          response = "Connected to Device!";
        });
        _startListening();
      } else {
        setState(() {
          response = "Failed to connect";
        });
      }
    } catch (e) {
      setState(() {
        response = "Error connecting: $e";
      });
    }
  }

  void _startListening() {
    subscription?.cancel();
    subscription = espService.messages.listen((receivedMessage) async {
      if (!mounted) return;
      setState(() {
        response = "Received: $receivedMessage";
      });

      if (receivedMessage == "Connected with Device") {
        final prefs = await SharedPreferences.getInstance();
        final bool hasCompletedSetup = prefs.getBool('setup_complete') ?? false;

        debugPrint(
          "setup complete: $hasCompletedSetup and message: $receivedMessage",
        );

        if (!mounted) return;
        if (hasCompletedSetup) {
          _showLoaderAndNavigate(context, AppRoutes.mainScreen);
          debugPrint("go to main screen");
        } else {
          _showLoaderAndNavigate(context, AppRoutes.wifiConfig);
          debugPrint("go to wifi config");
        }
      } else if (receivedMessage.startsWith("error")) {
        showCustomSnackBar(
          context,
          "Connection error: $receivedMessage",
          c.darkColor,
        );
      } else if (receivedMessage == "disconnected") {
        showCustomSnackBar(context, "Disconnected from Device", c.darkColor);
      }
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  void _showLoaderAndNavigate(BuildContext context, String route) {
    if (!context.mounted) return;
    final navigator = Navigator.of(context);
    showLoader(context, "Verifying connection...");
    Future.delayed(Duration(seconds: 3), () {
      if (!context.mounted) return;
      navigator.pop();
      Navigator.pushReplacementNamed(context, route);
    });
  }

  void _showContinueDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: c.lightColor,
            title: Text(
              "Ready to Connect?",
              style: TextStyle(color: c.darkColor),
            ),
            content: Text(
              "Have you connected to the Device hotspot?",
              style: TextStyle(color: c.darkColor),
            ),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: Text("Go Back", style: TextStyle(color: c.darkColor)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.darkColor,
                  foregroundColor: c.lightColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  connectToESP32();
                },
                child: const Text("Continue"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: c.lightColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'X',
                    style: TextStyle(
                      color: c.primaryColor,
                      fontSize: 40,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: 'ALT',
                    style: TextStyle(
                      color: c.darkColor,
                      fontSize: 40,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Row(
                  children: [
                    Icon(Icons.bluetooth, size: 25, color: c.darkColor),
                    SizedBox(width: 8),
                    Text(
                      'Not Connect',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: c.darkColor,
                        fontSize: 12,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 50),
                Row(
                  children: [
                    Icon(Icons.wifi, size: 25, color: c.darkColor),
                    SizedBox(width: 8),
                    Text(
                      'Not Connect',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: c.darkColor,
                        fontSize: 12,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            Image.asset('assets/images/device.png', height: 250),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                final result = await showConnectionDialog(context);

                if (result == 'wifi') {
                  AppSettings.openAppSettings(type: AppSettingsType.wifi);
                  Future.delayed(Duration(seconds: 3), () {
                    if (context.mounted) {
                      _showContinueDialog(context);
                    }
                  });
                } else if (result == 'bluetooth') {
                  AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: c.lightColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
                fixedSize: const Size(300, 50),
                backgroundColor: c.darkColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Center(
                child: Text(
                  'Connect to Device',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: c.lightColor,
                    fontSize: 16,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
