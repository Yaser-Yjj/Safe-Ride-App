import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';
import 'package:safe_ride_app/data/bluetooth/config_service.dart';
import 'package:safe_ride_app/presentation/routes/app_routes.dart';
import 'package:safe_ride_app/presentation/widgets/main/app_bar.dart';
import 'package:safe_ride_app/presentation/widgets/splash/custome_snackbar.dart';

class WifiConfigScreen extends StatefulWidget {
  const WifiConfigScreen({super.key});

  @override
  State<WifiConfigScreen> createState() => _WifiConfigScreenState();
}

class _WifiConfigScreenState extends State<WifiConfigScreen> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _ssidFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String? _ssidError;
  String? _passwordError;

  void _validateAndSend() {
    final ssid = _ssidController.text.trim();
    final password = _passwordController.text.trim();

    bool isValid = true;

    if (ssid.isEmpty) {
      setState(() {
        _ssidError = "SSID is required";
      });
      showCustomSnackBar(context, "Please enter a valid SSID.", c.errorColor);
      _ssidFocus.requestFocus();
      isValid = false;
    } else if (!RegExp(r'^[a-zA-Z0-9_\- ]+$').hasMatch(ssid)) {
      setState(() {
        _ssidError = "Only letters, numbers, spaces, or - _ allowed";
      });
      showCustomSnackBar(context, "Invalid SSID format.", c.errorColor);
      _ssidFocus.requestFocus();
      isValid = false;
    } else {
      setState(() {
        _ssidError = null;
      });
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = "Password is required";
      });
      showCustomSnackBar(context, "Password cannot be empty.", c.errorColor);
      _passwordFocus.requestFocus();
      isValid = false;
    } else if (password.length < 8) {
      setState(() {
        _passwordError = "Password must be at least 8 characters";
      });
      showCustomSnackBar(
        context,
        "Password must be at least 8 characters.",
        c.errorColor,
      );
      _passwordFocus.requestFocus();
      isValid = false;
    } else {
      setState(() {
        _passwordError = null;
      });
    }

    if (isValid) {
      ConfigService().updateConfig((config) {
        config.ssid = ssid;
        config.password = password;
      });

      Navigator.pushNamed(context, AppRoutes.fullName);
    }
  }

  @override
  void initState() {
    super.initState();

    _ssidController.addListener(() {
      if (_ssidError != null && _ssidController.text.isNotEmpty) {
        setState(() {
          _ssidError = null;
        });
      }
    });

    _passwordController.addListener(() {
      if (_passwordError != null && _passwordController.text.isNotEmpty) {
        setState(() {
          _passwordError = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    _ssidFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: c.lightColor,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                cursorColor: c.darkColor,
                cursorErrorColor: c.errorColor,
                controller: _ssidController,
                focusNode: _ssidFocus,
                style: TextStyle(color: c.darkColor),
                decoration: InputDecoration(
                  labelText: "Wi-Fi SSID",
                  labelStyle: TextStyle(color: c.darkColor),
                  hintText: "e.g. MyHomeNetwork",
                  hintStyle: TextStyle(color: c.darkColor.withOpacity(0.6)),
                  prefixIcon: Icon(Icons.wifi, color: c.darkColor),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: c.darkColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _ssidError != null ? c.errorColor : c.darkColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),

              SizedBox(height: 20),

              TextFormField(
                cursorColor: c.darkColor,
                cursorErrorColor: c.errorColor,
                controller: _passwordController,
                focusNode: _passwordFocus,
                style: TextStyle(color: c.darkColor),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: c.darkColor),
                  hintText: "At least 8 characters",
                  hintStyle: TextStyle(color: c.darkColor.withOpacity(0.6)),
                  prefixIcon: Icon(Icons.lock, color: c.darkColor),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: c.darkColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          _passwordError != null ? c.errorColor : c.darkColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 50),
        padding: const EdgeInsets.all(16),
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: _validateAndSend,
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
