import 'package:flutter/material.dart';

import '../config/colors.dart';

class HolidayContainer extends StatelessWidget {
  final String title;
  final String date;
  final String day;
  final String? imageUrl;
  final int index;

  const HolidayContainer({
    super.key,
    required this.title,
    required this.date,
    required this.day,
    this.imageUrl,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [tBorBlueColor, tBorderGreenColor, tBorderLightGreenColor];
    final borderColor = colors[index.isNegative ? 0 : index % colors.length];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xfff5f8ff),
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontSize: 16),
          ),
          Text(
            day,
            style:
                Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),
          ),
          Text(date, style: Theme.of(context).textTheme.bodySmall),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (imageUrl != null)
                  Image.network(
                    imageUrl!,
                    height: 50,
                    width: 50,
                    fit: BoxFit.contain,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
