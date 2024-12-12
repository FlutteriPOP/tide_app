import 'package:flutter/material.dart';

import '../config/colors.dart';
import '../config/themes.dart';

class CustomCheckInCard extends StatelessWidget {
  final String checkInTime;
  final String checkInStatus;
  final String expectedTime;
  final String imageUrl;
  final Color color;

  const CustomCheckInCard({
    super.key,
    required this.color,
    required this.checkInTime,
    required this.checkInStatus,
    required this.expectedTime,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.3,
      color: tTextwhiteColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: color,
                  child: Image.asset(
                    imageUrl,
                    width: 20,
                    height: 20,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  checkInStatus,
                  style: const TextStyle(
                    fontFamily: tmSatoshi,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: tFontcolor,
                  ),
                )
              ],
            ),
            const SizedBox(height: 7),
            Text(
              checkInTime,
              style: const TextStyle(
                fontFamily: tbSatoshi,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: tFontcolor,
              ),
            ),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'On Time:',
                  style: TextStyle(
                    fontFamily: tbSatoshi,
                    fontSize: 12,
                    color: tFontcolor,
                  ),
                ),
                Text(
                  expectedTime,
                  style: const TextStyle(
                    fontFamily: tbSatoshi,
                    fontSize: 13,
                    color: tFontcolor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
