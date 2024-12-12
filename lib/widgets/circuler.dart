import 'package:flutter/material.dart';

class MyCircularIndicator extends StatelessWidget {
  final Color? color;
  const MyCircularIndicator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 7,
        color: color,
      ),
    );
  }
}
