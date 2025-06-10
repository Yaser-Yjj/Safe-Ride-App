import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void handleSignOut() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final navigator = navigatorKey.currentState;

    if (navigator != null) {
      ScaffoldMessenger.of(navigator.context).showSnackBar(
        SnackBar(content: Text("Device disconnected → Signing out")),
      );

      navigator.pushNamedAndRemoveUntil(
        "/", 
        (route) => false,
      );
    } else {
      debugPrint("⚠️ Can't navigate during sign-out – navigatorKey not ready");
    }
  });
}