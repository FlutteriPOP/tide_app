import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipop_tracker/screens/other/home.dart';
import 'package:ipop_tracker/screens/other/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
  }

  Future _checkSignInStatus() async {
    // Retrieve the token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Check if the token exists and is not empty
    if (token!.isNotEmpty) {
      isSignedIn = true;
    }

    // Use Future.delayed instead of Timer for a more modern approach
    await Future.delayed(const Duration(seconds: 3));
    Get.off(() => isSignedIn ? const HomeScreen() : const WelcomePage(),
        transition: Transition.fade);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tTextwhiteColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset('assets/images/frame.png'),
              ],
            ),
          ),
          Image.asset(
            'assets/images/splash.png',
            height: 220,
            width: 230,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/frame2.png',
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
