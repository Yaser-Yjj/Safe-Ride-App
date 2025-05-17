import 'package:flutter/material.dart';
import 'package:safe_ride_app/presentation/widgets/main/app_bar.dart';
import 'package:safe_ride_app/presentation/widgets/main/custom_floating_button.dart';
import 'package:safe_ride_app/presentation/widgets/main/custom_bottom_navigation_bar.dart';
import 'package:safe_ride_app/presentation/widgets/main/show_bubble_popup.dart';
import 'home/home_page.dart';
import 'maps/maps_page.dart';
import 'history/history_page.dart';
import 'settings/settings.dart';
import 'package:safe_ride_app/core/theme/theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  GlobalKey iconKey = GlobalKey();

  void _onPageSelected(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c.lightColor,
      appBar: CustomAppBar(
        svgIconPath: 'assets/icons/notifications.svg',
        onIconPressed: () {
          showBubblePopup(context, iconKey);
        },
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CustomFloatingButton(
        onPressed: () => _onPageSelected(0),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onPageSelected: _onPageSelected,
      ),
    );
  }

  List<Widget> get _pages => List.generate(4, (index) {
    if (index == _selectedIndex) {
      return _buildPage(index);
    }
    return const SizedBox();
  });

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const MapsPage();
      case 2:
        return const HistoryPage();
      case 3:
        return const SettingsPage();
      default:
        return const SizedBox();
    }
  }
}
