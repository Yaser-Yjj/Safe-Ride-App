import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:safe_ride_app/data/bluetooth/ESP32Service.dart';
import 'package:safe_ride_app/presentation/routes/app_routes.dart';
import 'package:safe_ride_app/presentation/widgets/main/app_bar.dart';
import 'package:safe_ride_app/presentation/widgets/splash/custome_snackbar.dart';
import 'package:safe_ride_app/presentation/widgets/splash/loader.dart';

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
    espService = ESP32Service(); // ✅ Use singleton
  }

  Future<void> connectToESP32() async {
    try {
      await espService.connect(ip, port);
      if (espService.connected) {
        setState(() {
          response = "Connected to ESP32!";
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
    // ✅ Cancel previous subscription before starting a new one
    subscription?.cancel();
    subscription = espService.messages.listen((receivedMessage) {
      if (!mounted) return;
      setState(() {
        response = "Received: $receivedMessage";
      });
      if (receivedMessage == "Connected with Device") {
        _showLoaderAndNavigate(context);
      } else if (receivedMessage.startsWith("error")) {
        showCustomSnackBar(context, "Connection error: $receivedMessage");
      } else if (receivedMessage == "disconnected") {
        showCustomSnackBar(context, "Disconnected from ESP32");
      }
    });
  }

  @override
  void dispose() {
    subscription?.cancel(); // ✅ Clean up
    super.dispose();
  }

  void _showLoaderAndNavigate(BuildContext context) {
    if (!context.mounted) return;
    final navigator = Navigator.of(context);
    showLoader(context, "Verifying connection...");
    Future.delayed(Duration(seconds: 3), () {
      if (!context.mounted) return;
      navigator.pop();
      Navigator.pushReplacementNamed(context, AppRoutes.wifiConfig);
    });
  }

  void _showContinueDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text("Ready to Connect?"),
            content: Text("Have you connected to the ESP32 hotspot?"),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: Text("Go Back"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  connectToESP32();
                },
                child: Text("Continue"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Status: $response", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                AppSettings.openAppSettings(type: AppSettingsType.wifi);
                Future.delayed(Duration(seconds: 2), () {
                  if (context.mounted) {
                    _showContinueDialog(context);
                  }
                });
              },
              child: Text("Connect to ESP32"),
            ),
          ],
        ),
      ),
    );
  }
}
