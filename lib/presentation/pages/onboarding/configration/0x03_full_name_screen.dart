import 'package:flutter/material.dart';
import 'package:safe_ride_app/data/bluetooth/config_service.dart';
import 'package:safe_ride_app/presentation/routes/app_routes.dart';
import 'package:safe_ride_app/presentation/widgets/main/app_bar.dart';

class FullNameScreen extends StatefulWidget {
  const FullNameScreen({super.key});

  @override
  State<FullNameScreen> createState() => _FullNameScreenState();
}

class _FullNameScreenState extends State<FullNameScreen> {
  final TextEditingController _fullNameController = TextEditingController();

  void _saveAndContinue() {
    String fullName = _fullNameController.text.trim();

    if (fullName.isEmpty) return;

    ConfigService().updateConfig((config) {
      config.fullName = fullName;
    });

    Navigator.pushNamed(context, AppRoutes.contacts, arguments: 1);

  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: "Enter your full name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveAndContinue,
              icon: Icon(Icons.arrow_forward),
              label: Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
