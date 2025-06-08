import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safe_ride_app/core/theme/theme.dart';

class SettingItem extends StatelessWidget {
  final IconData? materialIcon;
  final String? svgIconPath;
  final String title;
  final VoidCallback onTap;

  const SettingItem({
    super.key,
    this.materialIcon,
    this.svgIconPath,
    required this.title,
    required this.onTap,
  }) : assert(
         (materialIcon != null && svgIconPath == null) ||
             (svgIconPath != null && materialIcon == null),
         "Only one icon type should be provided",
       );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildLeadingIcon(),
      title: Text(
        title,
        style: TextStyle(
          color: c.darkColor,
          fontSize: 16,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: SvgPicture.asset(
        "assets/icons/next_flesh.svg",
        width: 24,
        height: 24,
        placeholderBuilder:
            (context) => SizedBox(
              width: 24,
              height: 24,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 1.5),
              ),
            ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildLeadingIcon() {
    if (materialIcon != null) {
      return Icon(materialIcon, color: c.darkColor);
    } else if (svgIconPath != null) {
      return SvgPicture.asset(
        svgIconPath!,
        width: 24,
        height: 24,
        placeholderBuilder:
            (context) => SizedBox(
              width: 24,
              height: 24,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 1.5),
              ),
            ),
      );
    } else {
      return const SizedBox(width: 24, height: 24);
    }
  }
}
