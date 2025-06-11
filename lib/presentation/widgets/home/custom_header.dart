import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';

class ReusableHeader extends StatelessWidget {
  final String title;
  final String description;

  const ReusableHeader({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: c.darkColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: c.darkColor.withAlpha((0.7 * 255).toInt()),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}