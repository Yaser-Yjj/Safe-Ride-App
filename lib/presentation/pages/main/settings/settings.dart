import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(children: [Title(color: c.darkColor, child: Text("yaser"))]),
    );
  }
}
