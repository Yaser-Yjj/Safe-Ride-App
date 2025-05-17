import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:safe_ride_app/data/bluetooth/ESP32Service.dart';
import 'package:safe_ride_app/data/bluetooth/config_service.dart';
import 'package:safe_ride_app/presentation/routes/app_routes.dart';
import 'package:safe_ride_app/presentation/widgets/main/app_bar.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

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
            Text("Wi-Fi SSID: ${config.ssid ?? "SafeRide Device"}"),
            Text("Full Name: ${config.fullName ?? "123456789"}"),
            SizedBox(height: 16),
            Text("Emergency Contacts:"),
            Text("1. ${config.contact1Name} - ${config.contact1Number}"),
            Text("2. ${config.contact2Name} - ${config.contact2Number}"),
            Text("3. ${config.contact3Name} - ${config.contact3Number}"),
            Spacer(),
            ElevatedButton.icon(
              onPressed: () async {
                final config = ConfigService().config;

                final Map<String, String?> jsonData = {
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

                await ESP32Service().sendMessage(jsonString);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Settings sent to device")),
                  );
                 Navigator.pushReplacementNamed(context, AppRoutes.done);
                }
              },
              icon: Icon(Icons.send),
              label: Text("Apply Settings"),
            ),
          ],
        ),
      ),
    );
  }
}
