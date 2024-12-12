import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipop_tracker/screens/other/welcome_screen.dart';
import 'package:ipop_tracker/widgets/buttion.dart';
import 'package:lottie/lottie.dart';

import '../../config/colors.dart';

class DonePage extends StatelessWidget {
  final String? mainText;
  final String? subText;

  const DonePage({super.key, this.mainText, this.subText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tTextwhiteColor,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        LottieBuilder.asset('assets/Animation/done.json'),
        Center(
          child: Text(mainText!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              subText!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: tTextblackColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: InkWell(
            onTap: () {
              Get.offAll(() => const WelcomePage(),
                  transition: Transition.cupertino);
            },
            child: const MyButton(
              text: 'Done',
            ),
          ),
        ),
      ]),
    );
  }
}
