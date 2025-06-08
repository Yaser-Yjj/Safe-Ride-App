import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';
import 'package:app_settings/app_settings.dart';
import 'package:safe_ride_app/presentation/widgets/home/connection_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c.lightColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            const SizedBox(height: 30),
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
                SizedBox(width: 40),
                Row(
                  children: [
                    Icon(Icons.wifi, size: 25, color: c.darkColor),
                    SizedBox(width: 8),
                    Text(
                      'Connected',
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
            const SizedBox(height: 30),
            Image.asset('assets/images/device.png', height: 180),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final result = await showConnectionDialog(context);

                if (result == 'wifi') {
                  AppSettings.openAppSettings(type: AppSettingsType.wifi);
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
