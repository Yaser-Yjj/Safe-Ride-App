import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';
import 'package:safe_ride_app/data/services/config_service.dart';
import 'package:safe_ride_app/presentation/routes/app_routes.dart';
import 'package:safe_ride_app/presentation/widgets/main/app_bar.dart';
import 'package:safe_ride_app/presentation/widgets/splash/custome_snackbar.dart';

class FullNameScreen extends StatefulWidget {
  const FullNameScreen({super.key});

  @override
  State<FullNameScreen> createState() => _FullNameScreenState();
}

class _FullNameScreenState extends State<FullNameScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final FocusNode _fullNameFocus = FocusNode();

  String? _fullNameError;

  void _saveAndContinue() {
    String fullName = _fullNameController.text.trim();

    bool isValid = true;

    if (fullName.isEmpty) {
      setState(() {
        _fullNameError = "Full name is required";
      });
      showCustomSnackBar(context, "Please enter your full name.", c.errorColor);
      _fullNameFocus.requestFocus();
      isValid = false;
    }

    if (isValid) {
      ConfigService().updateConfig((config) {
        config.fullName = fullName;
      });

      Navigator.pushNamed(context, AppRoutes.contacts, arguments: 1);
    }
  }

  @override
  void initState() {
    super.initState();

    _fullNameController.addListener(() {
      if (_fullNameError != null && _fullNameController.text.isNotEmpty) {
        setState(() {
          _fullNameError = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _fullNameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: c.lightColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          children: [
            TextField(
              controller: _fullNameController,
              focusNode: _fullNameFocus,
              decoration: InputDecoration(
                labelText: "Enter your full name",
                labelStyle: TextStyle(color: c.darkColor),
                hintText: "e.g. Yasser Yjjou",
                hintStyle: TextStyle(color: c.darkColor.withAlpha((0.6 * 255).toInt())),
                prefixIcon: Icon(Icons.person, color: c.darkColor),
                filled: true,
                fillColor: Colors.white,
                errorText: _fullNameError,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: c.darkColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _fullNameError != null ? c.errorColor : c.darkColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 50),
        padding: const EdgeInsets.all(16),
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: _saveAndContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: c.darkColor,
            foregroundColor: c.lightColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            elevation: 3,
          ),
          child: Text("Continue"),
        ),
      ),
    );
  }
}
