import 'package:flutter/material.dart';
import 'dart:io';

import 'package:safe_ride_app/core/theme/theme.dart';

void main() {
  runApp(const SafeRideApp());
}

class SafeRideApp extends StatelessWidget {
  const SafeRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("ESP32 Communicator")),
        body: ESP32Controller(),
      ),
    );
  }
}

class ESP32Controller extends StatefulWidget {
  const ESP32Controller({super.key});

  @override
  State<ESP32Controller> createState() => _ESP32ControllerState();
}

class _ESP32ControllerState extends State<ESP32Controller> {
  late Socket socket;
  final ip = "192.168.4.1";
  final port = 3333;
  String response = "No response yet";
  String message = "";
  List<String> messageHistory = [];

  Future<void> connectToESP32() async {
    try {
      socket = await Socket.connect(ip, port);
      setState(() {
        response = "Connected to ESP32!";
      });

      socket.listen(
        (data) {
          String receivedMessage = String.fromCharCodes(data).trim();

          if (receivedMessage.isNotEmpty) {
            setState(() {
              response = receivedMessage;
              messageHistory.insert(0, receivedMessage);
            });
          } else {
            _showCustomSnackBar(context, "empty response");
          }
        },
        onError: (error) {
          setState(() {
            response = "Connection error.";
            _showCustomSnackBar(context, response);
          });
        },
        onDone: () {
          setState(() {
            response = "Disconnected.";
            _showCustomSnackBar(context, response);
          });
        },
      );
    } catch (e) {
      setState(() {
        response = "Failed to connect: $e";
        _showCustomSnackBar(context, response);
      });
    }
  }

  void sendMessage() {
    if (message.isNotEmpty) {
      socket.write(message);
    } else {
      _showCustomSnackBar(context, "Message is Empty");
    }
  }

  void _showCustomSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      backgroundColor: c.darkColor,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      duration: const Duration(seconds: 7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentMaterialBanner()
      ..showSnackBar(snackBar);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Status: $response", style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Expanded(
            child:
                messageHistory.isEmpty
                    ? Center(child: Text("No messages yet"))
                    : ListView.builder(
                      itemCount: messageHistory.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.grey[300],
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(title: Text(messageHistory[index])),
                        );
                      },
                    ),
          ),
          SizedBox(height: 20),
          TextField(
            onChanged: (val) => message = val,
            decoration: InputDecoration(labelText: "Enter message"),
          ),
          ElevatedButton(onPressed: sendMessage, child: Text("Send Message")),
          ElevatedButton(
            onPressed: connectToESP32,
            child: Text("Connect to ESP32"),
          ),
        ],
      ),
    );
  }
}
