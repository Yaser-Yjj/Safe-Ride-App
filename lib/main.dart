import 'package:flutter/material.dart';
import 'package:safe_ride_app/presentation/widgets/main/custom_floating_button.dart';
import 'package:safe_ride_app/presentation/widgets/main/custom_bottom_navigation_bar.dart';
import 'package:safe_ride_app/presentation/widgets/main/show_bubble_popup.dart';
import 'package:safe_ride_app/core/utils/bluetooth_check_page.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
      routes: {
        '/connected': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/bluetooth-check') {
          return MaterialPageRoute(
            builder: (_) => const BluetoothCheckPage(),
          );
        }
        return null;
      },
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

  void _navigateToBluetoothCheck(BuildContext context) {
    Navigator.pushNamed(context, '/bluetooth-check');
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
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: const [HomePage(), MapsPage(), HistoryPage(), SettingsPage()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CustomFloatingButton(
        onPressed: () => _navigateToBluetoothCheck(context), // ← Trigger check
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onPageSelected: _onPageSelected,
      ),
    );
  }
}
