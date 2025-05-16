import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothCheckPage extends StatefulWidget {
  const BluetoothCheckPage({super.key});

  @override
  State<BluetoothCheckPage> createState() => _BluetoothCheckPageState();
}

class _BluetoothCheckPageState extends State<BluetoothCheckPage> {
  bool _isConnected = false;
  String? _receivedData;
  BluetoothDevice? _device;

  Future<void> _startScanAndConnect(BuildContext context) async {
    // Tcheck ay device connecté awalu
    final connectedDevices = await FlutterBluePlus.connectedDevices;
    if (connectedDevices.isNotEmpty) {
      final espDevice = connectedDevices.firstWhere(
        (d) => d.name.contains("SafeRide"),
        orElse: () => null,
      );

      if (espDevice != null) {
        setState(() {
          _device = espDevice;
          _isConnected = true;
        });

        _startListeningForData(context, espDevice);
        return;
      }
    }

    // Ila ma kanachi connecté → scan for devices
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.foundDevices.listen((devices) async {
      for (var device in devices) {
        if (device.name.contains("SafeRide")) {
          FlutterBluePlus.stopScan();

          try {
            await device.connect();
            setState(() {
              _device = device;
              _isConnected = true;
            });

            _startListeningForData(context, device);
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Connection failed: $e")));
          }

          break;
        }
      }
    });
  }

  void _startListeningForData(BuildContext context, BluetoothDevice device) {
    device.discoverServices().then((services) {
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.notify) {
            characteristic.setNotifyValue(true);

            characteristic.value.listen((value) {
              String data = String.fromCharCodes(value);

              if (data.trim() == 'A') {
                Navigator.pushReplacementNamed(context, '/connected');
              }

              setState(() {
                _receivedData = data;
              });
            });
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScanAndConnect(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isConnected)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Connecting to ESP32..."),
                ],
              )
            else
              Column(
                children: [
                  const Icon(
                    Icons.bluetooth_connected,
                    size: 60,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  const Text("Connected to ESP32"),
                  const SizedBox(height: 10),
                  Text("Received: $_receivedData"),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
