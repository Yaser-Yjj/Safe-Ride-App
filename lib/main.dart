import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';
import 'package:safe_ride_app/data/services/accident_handler.dart';
import 'package:safe_ride_app/data/services/auth_service.dart';
import 'package:safe_ride_app/presentation/pages/onboarding/configration/0x01_connect_device.dart';
import 'package:safe_ride_app/presentation/routes/app_router.dart';
import 'package:safe_ride_app/presentation/routes/app_routes.dart';

void main() {
  runApp(const SafeRideApp());
}

class SafeRideApp extends StatelessWidget {
  const SafeRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Safe Ride",
      initialRoute: AppRoutes.connectDevice,
      onGenerateRoute: AppRouter.generateRoute,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: c.darkColor,
          selectionColor: c.grisColor,
          selectionHandleColor: c.darkColor,
        ),
      ),
      home: AccidentHandler( 
        navigatorKey: navigatorKey,
        child: const ESP32Controller(),
      ),
    );
  }
}
