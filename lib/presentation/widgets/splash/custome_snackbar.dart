import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 280, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      animation: _createTopToBottomAnimation(),
    ),
  );
}

Animation<double> _createTopToBottomAnimation() {
  return Tween<double>(begin: 100, end: 0).animate(
    CurvedAnimation(parent: AlwaysStoppedAnimation(1), curve: Curves.easeIn),
  );
}
