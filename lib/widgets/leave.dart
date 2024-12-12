import 'package:flutter/material.dart';

import '../config/colors.dart';

class CustomContainer extends StatelessWidget {
  final String leave;
  final String leaveType;
  final String leaveNumber;
  final Color? borderColor;
  final Color? countColor;

  const CustomContainer(
      {super.key,
      required this.leave,
      required this.leaveNumber,
      required this.leaveType,
      this.borderColor,
      this.countColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        border:
            Border.all(color: borderColor ?? tTextTrasparentColor, width: 1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(leave,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headlineMedium),
          Text(leaveType, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 5.0),
          Text(
            leaveNumber,
            style: TextStyle(
              fontSize: 20.0,
              color: countColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
