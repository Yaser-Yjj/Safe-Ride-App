// file: connected_home_page.dart
import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';

class ConnectedHomePage extends StatelessWidget {
  const ConnectedHomePage({super.key});

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
                    Icon(Icons.bluetooth, size: 25, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Connected',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green,
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
            const SizedBox(height: 30),
            Image.asset('assets/images/device_connected.png', height: 180),
            const SizedBox(height: 30),
            const Text(
              'You are now connected to your device.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: c.darkColor,
                fontSize: 16,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}