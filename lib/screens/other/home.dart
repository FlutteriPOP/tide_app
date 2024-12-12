import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ipop_tracker/config/colors.dart';
import 'package:ipop_tracker/controller/location.dart';
import 'package:ipop_tracker/screens/Leave/leave.dart';
import 'package:ipop_tracker/screens/Setting/setting.dart';
import 'package:ipop_tracker/screens/profile/dashbord.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../History/history.dart';
import '../scanner/qr_screean.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final LocationController locationController = Get.put(LocationController());

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashBordPage(),
    const LeavePage(),
    const HistoryPage(),
    const SettingPage(),
  ];

  final List<IconData> iconList = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.rightToBracket,
    FontAwesomeIcons.clockRotateLeft,
    FontAwesomeIcons.gear,
  ];

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  @override
  void dispose() {
    locationController.onClose();
    super.dispose();
  }

  Future<void> checkPermission() async {
    final prefs = await SharedPreferences.getInstance();
    String? permission = prefs.getString('permission');
    if (permission == '1') {
      locationController.getCurrentPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tTextwhiteColor,
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        heroTag: 'scanner',
        elevation: 0,
        backgroundColor: tsecondaryColor,
        shape: const CircleBorder(),
        onPressed: () {
          Get.to(() => const QrScreen());
        },
        child: const Icon(
          Icons.qr_code_scanner_rounded,
          size: 34,
          color: tTextwhiteColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _selectedIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 15,
        rightCornerRadius: 15,
        iconSize: 25,
        height: 70,
        onTap: (index) => setState(() => _selectedIndex = index),
        activeColor: tTextwhiteColor,
        inactiveColor: Colors.white60,
        backgroundColor: tsecondaryColor,
      ),
    );
  }
}
