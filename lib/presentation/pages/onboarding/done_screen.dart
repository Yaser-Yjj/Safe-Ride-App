import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';
import 'package:safe_ride_app/presentation/routes/app_routes.dart';
import 'package:safe_ride_app/presentation/widgets/main/app_bar.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: c.lightColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              child: Image.asset('assets/images/Configuration_Success.png'),
            ),

            SizedBox(height: 32),

            Text(
              "Configuration Applied!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: c.darkColor,
              ),
            ),

            SizedBox(height: 16),

            Text(
              "Your settings have been successfully sent to the SafeRide device.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: c.darkColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 50),
        padding: const EdgeInsets.all(16),
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: () {
            if (!context.mounted) return;
            Navigator.popAndPushNamed(context, AppRoutes.mainScreen);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: c.darkColor,
            foregroundColor: c.lightColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            elevation: 3,
          ),
          child: Text("Apply Settings"),
        ),
      ),
    );
  }
}
