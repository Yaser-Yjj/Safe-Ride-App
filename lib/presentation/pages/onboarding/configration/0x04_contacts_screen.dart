import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';
import 'package:safe_ride_app/data/services/config_service.dart';
import 'package:safe_ride_app/presentation/routes/app_routes.dart';
import 'package:safe_ride_app/presentation/widgets/main/app_bar.dart';
import 'package:safe_ride_app/presentation/widgets/splash/custome_snackbar.dart';

class ContactsScreen extends StatefulWidget {
  final int contactIndex;

  const ContactsScreen({super.key, required this.contactIndex});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _numberController;

  late FocusNode _nameFocus;
  late FocusNode _numberFocus;

  String? _nameError;
  String? _numberError;

  @override
  void initState() {
    super.initState();

    _nameFocus = FocusNode();
    _numberFocus = FocusNode();

    _nameController = TextEditingController();
    _numberController = TextEditingController();

    _nameController.addListener(() {
      if (_nameError != null && _nameController.text.isNotEmpty) {
        setState(() {
          _nameError = null;
        });
      }
    });

    _numberController.addListener(() {
      if (_numberError != null && _numberController.text.isNotEmpty) {
        setState(() {
          _numberError = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _nameFocus.dispose();
    _numberFocus.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    final name = _nameController.text.trim();
    final number = _numberController.text.trim();

    bool isValid = true;

    if (name.isEmpty) {
      setState(() {
        _nameError = "Name is required";
      });
      showCustomSnackBar(context, "Please enter a valid name.", c.errorColor);
      _nameFocus.requestFocus();
      isValid = false;
    }

    final phoneError = validatePhoneNumber(_numberController.text);
    if (phoneError != null) {
      setState(() {
        _numberError = phoneError;
      });
      showCustomSnackBar(context, phoneError, c.errorColor);
      _numberFocus.requestFocus();
      isValid = false;
    } else {
      setState(() {
        _numberError = null;
      });
    }

    if (isValid) {
      ConfigService().updateConfig((config) {
        switch (widget.contactIndex) {
          case 1:
            config.contact1Name = name;
            config.contact1Number = number;
            break;
          case 2:
            config.contact2Name = name;
            config.contact2Number = number;
            break;
          case 3:
            config.contact3Name = name;
            config.contact3Number = number;
            break;
        }
      });

      if (widget.contactIndex < 3) {
        Navigator.pushNamed(
          context,
          AppRoutes.contacts,
          arguments: widget.contactIndex + 1,
        );
      } else {
        Navigator.pushNamed(context, AppRoutes.summary);
      }
    }
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }

    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10) {
      return "Phone number must be at least 10 digits";
    }

    if (!RegExp(r'^\d+$').hasMatch(digitsOnly)) {
      return "Phone number must contain only digits";
    }

    return null;
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
                controller: _nameController,
                focusNode: _nameFocus,
                cursorColor: c.darkColor,
                cursorErrorColor: c.errorColor,
                style: TextStyle(color: c.darkColor),
                decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle: TextStyle(color: c.darkColor),
                  hintText: "e.g. Yasser Yjjou",
                  hintStyle: TextStyle(
                    color: c.darkColor.withAlpha((0.6 * 255).toInt()),
                  ),
                  prefixIcon: Icon(Icons.person, color: c.darkColor),
                  filled: true,
                  fillColor: Colors.white,
                  errorText: _nameError,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: c.darkColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _nameError != null ? c.errorColor : c.darkColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),

              SizedBox(height: 20),

              TextFormField(
                controller: _numberController,
                focusNode: _numberFocus,
                cursorColor: c.darkColor,
                cursorErrorColor: c.errorColor,
                style: TextStyle(color: c.darkColor),
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: TextStyle(color: c.darkColor),
                  hintText: "e.g. +212 608399120",
                  hintStyle: TextStyle(
                    color: c.darkColor.withAlpha((0.6 * 255).toInt()),
                  ),
                  prefixIcon: Icon(Icons.phone, color: c.darkColor),
                  filled: true,
                  fillColor: Colors.white,
                  errorText: _numberError,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: c.darkColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _numberError != null ? c.errorColor : c.darkColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.phone,
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
          child: Text("Save & Continue"),
        ),
      ),
    );
  }
}
