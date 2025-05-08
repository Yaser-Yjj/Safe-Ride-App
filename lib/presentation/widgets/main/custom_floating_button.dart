import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';

class CustomFloatingButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CustomFloatingButton({super.key, required this.onPressed});

  @override
  State<CustomFloatingButton> createState() => _CustomFloatingButtonState();
}

class _CustomFloatingButtonState extends State<CustomFloatingButton> {
  bool _isHovered = false;
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isTapped = true),
        onTapUp: (_) => setState(() => _isTapped = false),
        onTapCancel: () => setState(() => _isTapped = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: c.darkColor, width: 3),
            boxShadow: [
              BoxShadow(
                color:
                    (_isHovered || _isTapped)
                        ? c.primaryColor.withValues()
                        : c.darkColor.withValues(),
                spreadRadius: 4,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            backgroundColor: c.darkColor,
            onPressed: widget.onPressed,
            tooltip: 'Connect',
            elevation: 0,
            child: Icon(
              Icons.add,
              color: (_isHovered || _isTapped) ? c.primaryColor : c.lightColor,
            ),
          ),
        ),
      ),
    );
  }
}
