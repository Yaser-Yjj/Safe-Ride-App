import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';

Future<String?> showConnectionDialog(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: c.lightColor,
          title: Text(
            "Connection Method",
            style: TextStyle(
              color: c.darkColor,
              fontSize: 16,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            "Choose how you want to connect to the device.",
            style: TextStyle(
              color: c.darkColor,
              fontSize: 12,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'bluetooth');
              },
              child: Text(
                "Bluetooth",
                style: TextStyle(
                  color: c.darkColor,
                  fontSize: 12,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'wifi');
              },
              child: Text(
                "Wi-Fi",
                style: TextStyle(
                  color: c.darkColor,
                  fontSize: 12,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
  );
}
