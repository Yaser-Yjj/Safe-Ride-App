import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safe_ride_app/data/bluetooth/ESP32Service.dart';
import 'package:safe_ride_app/data/bluetooth/config_service.dart';
import 'package:safe_ride_app/presentation/routes/app_routes.dart';
import 'package:safe_ride_app/presentation/widgets/main/app_bar.dart';
import 'package:safe_ride_app/presentation/widgets/splash/custome_snackbar.dart';
import 'package:safe_ride_app/presentation/widgets/splash/loader.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool isLoading = false;
  late final ESP32Service espService;
  StreamSubscription<String>? _subscription;

  @override
  void initState() {
    super.initState();
    espService = ESP32Service(); 
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _sendConfig(BuildContext context) async {
    final config = ConfigService().config;
    final jsonData = {
      "config": "1",
      "ssid": config.ssid,
      "password": config.password,
      "fullName": config.fullName,
      "contact1Name": config.contact1Name,
      "contact1Number": config.contact1Number,
      "contact2Name": config.contact2Name,
      "contact2Number": config.contact2Number,
      "contact3Name": config.contact3Name,
      "contact3Number": config.contact3Number,
    };

    String jsonString = jsonEncode(jsonData);

    if (!espService.connected || espService.socket == null) {
      showCustomSnackBar(context, "Not connected to ESP32");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _subscription?.cancel();

      _subscription = espService.messages.listen(
        (response) {
          final trimmed = response.trim();
          debugPrint("Received from ESP32: $trimmed");

          if (trimmed == "done" && context.mounted) {
            _showLoaderAndNavigate(context);
          }
        },
        onError: (error) {
          if (context.mounted) {
            showCustomSnackBar(context, "Error in communication");
            setState(() {
              isLoading = false;
            });
          }
        },
        onDone: () {
          if (context.mounted) {
            showCustomSnackBar(context, "Disconnected from ESP32");
            setState(() {
              isLoading = false;
            });
          }
        },
      );

      await espService.sendMessage(jsonString);
    } catch (e) {
      if (context.mounted) {
        showCustomSnackBar(context, "Failed to send configuration");
      }
      debugPrint("Error sending JSON: $e");
    }
  }

  void _showLoaderAndNavigate(BuildContext context) {
    if (!context.mounted) return;
    final navigator = Navigator.of(context);
    showLoader(context, "Applying settings...");
    Future.delayed(const Duration(seconds: 3), () {
      if (!context.mounted) return;
      navigator.pop();
      navigator.pushReplacementNamed(AppRoutes.done);
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ConfigService().config;
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Wi-Fi SSID: ${config.ssid ?? "SafeRide-Device"}"),
            Text("Full Name: ${config.fullName ?? "Not Set"}"),
            const SizedBox(height: 16),
            const Text("Emergency Contacts:"),
            Text("1. ${config.contact1Name} - ${config.contact1Number}"),
            Text("2. ${config.contact2Name} - ${config.contact2Number}"),
            Text("3. ${config.contact3Name} - ${config.contact3Number}"),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: isLoading ? null : () => _sendConfig(context),
              icon:
                  isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.send),
              label:
                  isLoading
                      ? const Text("Sending...")
                      : const Text("Apply Settings"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
