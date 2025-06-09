import 'dart:async';
import 'package:flutter/material.dart';
import 'package:safe_ride_app/data/services/ESP32Service.dart';

class AccidentHandler extends StatefulWidget {
  final Widget child;

  const AccidentHandler({super.key, required this.child, required navigatorKey});

  @override
  State<AccidentHandler> createState() => _AccidentHandlerState();
}

class _AccidentHandlerState extends State<AccidentHandler>
    with WidgetsBindingObserver {
  late StreamSubscription<void> _accidentSubscription;

  @override
  void initState() {
    super.initState();

    debugPrint("🚨 AccidentHandler: Starting global accident listener");

    _accidentSubscription = ESP32Service().onAccident.listen((_) {
      debugPrint("🚨 Accident event received in Flutter!");
      if (mounted) {
        _showAccidentDialog(context);
      }
    });
  }

  void _showAccidentDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (_) => AlertDialog(
                backgroundColor: Colors.red.shade50,
                title: Text("⚠️ Emergency"),
                content: Text("An accident has been detected!"),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: Navigator.of(context).pop,
                    child: Text("Dismiss"),
                  ),
                ],
              ),
        );
      } catch (e) {
        debugPrint("🚨 Failed to show dialog: $e");
      }
    });
  }

  @override
  void dispose() {
    _accidentSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
