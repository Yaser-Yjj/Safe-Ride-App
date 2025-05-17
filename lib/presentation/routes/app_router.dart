// routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:safe_ride_app/presentation/pages/main/main_screen.dart';
import 'package:safe_ride_app/presentation/pages/onboarding/configration/0x01_connect_device.dart';
import 'package:safe_ride_app/presentation/pages/onboarding/configration/0x02_wifi_config_screen.dart';
import 'package:safe_ride_app/presentation/pages/onboarding/configration/0x03_full_name_screen.dart';
import 'package:safe_ride_app/presentation/pages/onboarding/configration/0x04_contacts_screen.dart';
import 'package:safe_ride_app/presentation/pages/onboarding/configration/0x05_summary_screen.dart';
import 'package:safe_ride_app/presentation/pages/onboarding/done_screen.dart';
import 'package:safe_ride_app/presentation/routes/app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.connectDevice:
        return MaterialPageRoute(builder: (_) => ESP32Controller());
      case AppRoutes.wifiConfig:
        return MaterialPageRoute(builder: (_) => WifiConfigScreen());
      case AppRoutes.fullName:
        return MaterialPageRoute(builder: (_) => FullNameScreen());
      case AppRoutes.contacts:
        final int contactIndex = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ContactsScreen(contactIndex: contactIndex),
        );
      case AppRoutes.summary:
        return MaterialPageRoute(builder: (_) => SummaryScreen());
      case AppRoutes.done:
        return MaterialPageRoute(builder: (_) => DoneScreen());
      case AppRoutes.mainScreen:
        return MaterialPageRoute(builder: (_) => MainScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(body: Center(child: Text('Page not found!'))),
        );
    }
  }
}
