import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';
import 'package:safe_ride_app/data/bluetooth/ESP32Service.dart';
import 'package:safe_ride_app/presentation/routes/app_routes.dart';
import 'package:safe_ride_app/presentation/widgets/main/app_bar.dart';
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

  Future<void> connectToESP32() async {
    final espService = ESP32Service();
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
  }

  void _startListening() {
    final espService = ESP32Service();

    if (espService.socket != null) {
      espService.socket!.listen(
        (data) {
          String receivedMessage = String.fromCharCodes(data).trim();

          if (receivedMessage.isNotEmpty && context.mounted) {
            if (receivedMessage == "Connected with Device") {
              _showLoaderAndNavigate(context);
            }
          }
        },
        onError: (error) {
          if (context.mounted) {
            setState(() {
              response = "Connection error.";
              _showCustomSnackBar(context, response);
            });
          }
        },
        onDone: () {
          if (context.mounted) {
            setState(() {
              response = "Disconnected.";
              _showCustomSnackBar(context, response);
            });
          }
        },
      );
    }
  }

  void _showCustomSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      backgroundColor: c.darkColor,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      duration: const Duration(seconds: 7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentMaterialBanner()
      ..showSnackBar(snackBar);
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
}
