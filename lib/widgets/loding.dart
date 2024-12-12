import 'package:flutter/material.dart';

import '../config/colors.dart';

class LodingPage extends StatelessWidget {
  final Color? color;

  const LodingPage({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tTextwhiteColor,
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 7,
          color: color,
          backgroundColor: tTextwhiteColor,
        ),
      ),
    );
  }
}
