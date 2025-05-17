import 'package:flutter/material.dart';
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
    );
  }
}
