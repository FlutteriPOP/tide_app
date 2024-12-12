import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipop_tracker/config/colors.dart';
import 'package:ipop_tracker/screens/Auth/company_registration.dart';

import '../../config/themes.dart';
import '../../widgets/container.dart';
import '../Auth/login_screen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tprimaryColor,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topRight,
            image: AssetImage(
              'assets/images/frame.png',
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/splash.png',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Welcome To',
                  style: TextStyle(
                    fontSize: 35,
                    fontFamily: tbSatoshi,
                    color: tsecondaryColor,
                  ),
                ),
                const Text(
                  'Track Tide!',
                  style: TextStyle(
                    fontSize: 35,
                    fontFamily: tbSatoshi,
                    color: tsecondaryColor,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Preparing for Your success trusted source in IT services for global providing.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: tsatoshi,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: tsecondaryColor,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const CompanyRegistration(),
                            transition: Transition.rightToLeft);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: MyContainer(
                          height: 190,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: tTextwhiteColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/company.png'),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Register As Company',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: tbSatoshi,
                                  fontSize: 20,
                                  color: tTextblackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => const LoginPage(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: MyContainer(
                          height: 190,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: tTextwhiteColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/person.png'),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Login As Employee',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: tbSatoshi,
                                  fontSize: 20,
                                  color: tTextblackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
