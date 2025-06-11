import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';
import 'package:safe_ride_app/data/services/ESP32Service.dart';
import 'package:safe_ride_app/presentation/widgets/home/setting_item.dart';
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        color: c.lightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/device.png',
                  height: 100,
                  width: 100,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Safe",
                            style: TextStyle(
                              color: c.darkColor,
                              fontSize: 25,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: "Ride",
                            style: TextStyle(
                              color: c.primaryColor,
                              fontSize: 25,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'X',
                            style: TextStyle(
                              color: c.primaryColor,
                              fontSize: 20,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: 'ALT',
                            style: TextStyle(
                              color: c.darkColor,
                              fontSize: 20,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),
            Text(
              "Application",
              style: TextStyle(
                color: c.darkColor.withAlpha((0.5 * 255).toInt()),
                fontSize: 18,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),

            SettingItem(
              svgIconPath: 'assets/icons/notification_settings.svg',
              title: "Notifications",
              onTap: () {},
            ),
            SettingItem(
              svgIconPath: 'assets/icons/app_language.svg',
              title: "language",
              onTap: () {},
            ),
            SettingItem(
              svgIconPath: 'assets/icons/theme.svg',
              title: "Theme",
              onTap: () {},
            ),
            SettingItem(
              svgIconPath: 'assets/icons/help_support.svg',
              title: "Privacy Policy",
              onTap: () {},
            ),

            const SizedBox(height: 20),

            Text(
              "Account",
              style: TextStyle(
                color: c.darkColor.withAlpha((0.5 * 255).toInt()),
                fontSize: 18,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            SettingItem(
              svgIconPath: 'assets/icons/logout.svg',
              title: "Sign Out",
              onTap: () {
                _showLogOutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

void _showLogOutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: c.lightColor,
      title: Text("Sign Out", style: TextStyle(color: c.darkColor)),
      content: Text(
        "Would you like to just sign out or delete all your data?",
        style: TextStyle(color: c.darkColor),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context); 

            final prefs = await SharedPreferences.getInstance();
            await prefs.clear(); 
            ESP32Service().disconnect();

            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            );
          },
          child: Text("Clear Data & Sign Out", style: TextStyle(color: c.darkColor)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: c.darkColor,
            foregroundColor: c.lightColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onPressed: () {
            ESP32Service().disconnect();

            Navigator.pop(context); 

            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            );
          },
          child: const Text("Sign Out Only"),
        ),
      ],
    ),
  );
}
