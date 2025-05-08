import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/theme.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onPageSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onPageSelected,
  });

  @override
  CustomBottomNavigationBarState createState() =>
      CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final List<String> _titles = ['Home', 'Maps', 'History', 'Settings'];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final barHeight = screenHeight * 0.12;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: BottomAppBar(
          color: c.darkColor,
          height: barHeight,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(4, (index) => _buildNavItem(index)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = widget.selectedIndex == index;
    return SizedBox(
      width: 50,
      height: 50,
      child: InkWell(
        onTap: () {
          widget.onPageSelected(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform:
              isSelected
                  ? Matrix4.translationValues(0, -10, 0)
                  : Matrix4.identity(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/${_titles[index]}.svg',
                width: 24,
                height: 24,
              ),
              const SizedBox(height: 4),
              Text(
                _titles[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: c.lightColor,
                  fontSize: 10,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
