import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';

void showCustomSnackBar(BuildContext context, String message) {
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