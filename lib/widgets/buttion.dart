import 'package:flutter/material.dart';

import '../config/colors.dart';

class MyButton extends StatelessWidget {
  final String? text;

  const MyButton({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: tContainerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text ?? '',
          style: const TextStyle(
            color: tTextwhiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
