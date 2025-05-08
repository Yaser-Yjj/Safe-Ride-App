import 'package:flutter/material.dart';
import 'package:safe_ride_app/presentation/widgets/main/custom_floating_button.dart';
import 'package:safe_ride_app/presentation/widgets/main/custom_bottom_navigation_bar.dart';
import 'package:safe_ride_app/presentation/widgets/main/show_bubble_popup.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/maps/maps_page.dart';
import 'presentation/pages/history/history_page.dart';
import 'presentation/pages/settings/settings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'core/theme/theme.dart';

void main() {
  runApp(const SafeRideApp());
}

class SafeRideApp extends StatelessWidget {
  const SafeRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

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
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Safe',
                style: TextStyle(
                  color: c.darkColor,
                  fontSize: 18,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: 'Ride',
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
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                key: iconKey,
                icon: SvgPicture.asset(
                  'assets/icons/notifications.svg',
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  showBubblePopup(context, iconKey);
                },
              );
            },
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: const [
          HomePage(),
          MapsPage(),
          HistoryPage(),
          SettingsPage(),
        ],
      ),
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
}
