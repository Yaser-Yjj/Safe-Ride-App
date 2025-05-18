import 'package:flutter/material.dart';
import 'package:safe_ride_app/data/bluetooth/config_service.dart';
import 'package:safe_ride_app/presentation/routes/app_routes.dart';
import 'package:safe_ride_app/presentation/widgets/main/app_bar.dart';

class ContactsScreen extends StatefulWidget {
  final int contactIndex;

  const ContactsScreen({super.key, required this.contactIndex});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _numberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    String name = _nameController.text.trim();
    String number = _numberController.text.trim();

    //if (name.isEmpty || number.isEmpty) return;

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
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _numberController,
              decoration: InputDecoration(labelText: "Phone Number"),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveAndContinue,
              icon: Icon(Icons.arrow_forward),
              label: Text("Save & Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
