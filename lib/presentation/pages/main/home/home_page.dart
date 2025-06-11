import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';
import 'package:safe_ride_app/data/services/ESP32Service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Color getIconColor(double yaw) {
    if (yaw.abs() > 65) {
      return c.errorColor;
    } else if (yaw.abs() > 30) {
      return c.primaryColor;
    } else {
      return c.darkColor; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final espService = ESP32Service(); 

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

            // Bluetooth + Wi-Fi status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.bluetooth, size: 25, color: c.darkColor),
                    const SizedBox(width: 8),
                    Text(
                      'Not Connected',
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
                const SizedBox(width: 40),
                Row(
                  children: [
                    Icon(Icons.wifi, size: 25, color: c.darkColor),
                    const SizedBox(width: 8),
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

            // YawDeg Live Value
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  children: [
                    Icon(Icons.battery_6_bar, size: 25, color: c.darkColor),
                    SizedBox(width: 8),
                    Text(
                      'Battery %',
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
                const SizedBox(width: 40),
                StreamBuilder<double>(
                  stream: espService.yawDegStream,
                  initialData: 0.0,
                  builder: (context, snapshot) {
                    double yaw = snapshot.data ?? 0.0;

                    return Row(
                      children: [
                        Icon(
                          Icons.compass_calibration,
                          size: 25,
                          color: getIconColor(yaw),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "YawDeg: ${yaw.toStringAsFixed(2)}°",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: getIconColor(yaw),
                            fontSize: 12,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}