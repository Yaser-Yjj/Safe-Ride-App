import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safe_ride_app/core/theme/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? svgIconPath;
  final VoidCallback? onIconPressed;

  const CustomAppBar({
    super.key,
    this.svgIconPath,
    this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "Safe",
              style: TextStyle(
                color: c.darkColor,
                fontSize: 18,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: "Ride",
              style: TextStyle(
                color: c.primaryColor,
                fontSize: 18,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: const Color(0x00000000),
      elevation: 0,
      actions: svgIconPath != null
          ? [
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: SvgPicture.asset(
                      svgIconPath!,
                      width: 24,
                      height: 24,
                    ),
                    onPressed: onIconPressed ?? () {},
                  );
                },
              ),
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}