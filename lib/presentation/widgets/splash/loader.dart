import 'package:flutter/material.dart';
import 'package:safe_ride_app/core/theme/theme.dart';

void showLoader(BuildContext context, String text) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => PopScope(
          canPop: false,
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              color: c.darkColor.withAlpha(
                (0.5 * 255).round(),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: c.lightColor,
                      strokeWidth: 4,
                    ),
                    SizedBox(height: 16),
                    Text(
                      text,
                      style: TextStyle(color: c.lightColor, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
  );
}
