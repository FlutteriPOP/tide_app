import 'package:flutter/material.dart';

import '../config/colors.dart';

class CustomListItem extends StatelessWidget {
  final String leadingAsset;
  final String title;
  final VoidCallback onTap;

  const CustomListItem({
    super.key,
    required this.leadingAsset,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: tprimaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Image.asset(
            leadingAsset,
            height: 20,
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          trailing: const Icon(
            Icons.arrow_circle_right_outlined,
            color: tTextblackColor,
          ),
        ),
      ),
    );
  }
}
