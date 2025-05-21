import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: c.darkColor.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: c.darkColor, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: c.darkColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: c.darkColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(String title, List<String> contacts) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: c.darkColor.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.phone, color: c.darkColor, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: c.darkColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...contacts.map((contact) {
            return Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Text(
                contact,
                style: TextStyle(
                  fontSize: 15,
                  color: c.darkColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

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
      showCustomSnackBar(context, "Not connected to ESP32", c.errorColor);
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
            showCustomSnackBar(context, "Error in communication", c.errorColor);
            setState(() {
              isLoading = false;
            });
          }
        },
        onDone: () {
          if (context.mounted) {
            showCustomSnackBar(context, "Disconnected from ESP32", c.darkColor);
            setState(() {
              isLoading = false;
            });
          }
        },
      );

      await espService.sendMessage(jsonString);
    } catch (e) {
      if (context.mounted) {
        showCustomSnackBar(
          context,
          "Failed to send configuration",
          c.darkColor,
        );
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
      backgroundColor: c.lightColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Configuration Summary",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: c.darkColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Review your settings before applying.",
                style: TextStyle(
                  fontSize: 14,
                  color: c.darkColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 30),

              _buildInfoCard(
                icon: Icons.wifi,
                title: "Wi-Fi Network",
                content: config.ssid ?? "SafeRide-Device",
              ),

              const SizedBox(height: 20),

              _buildInfoCard(
                icon: Icons.person,
                title: "Full Name",
                content: config.fullName ?? "Not Set",
              ),

              const SizedBox(height: 20),

              _buildContactCard("Emergency Contacts", [
                "1. ${config.contact1Name} - ${config.contact1Number}",
                "2. ${config.contact2Name} - ${config.contact2Number}",
                "3. ${config.contact3Name} - ${config.contact3Number}",
              ]),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 50),
        padding: const EdgeInsets.all(16),
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: () => _sendConfig(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: c.darkColor,
            foregroundColor: c.lightColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            elevation: 3,
          ),
          child: Text("Apply Settings"),
        ),
      ),
    );
  }
}
