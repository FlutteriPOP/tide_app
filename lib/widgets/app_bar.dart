import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/colors.dart';

class MyAppBar extends StatelessWidget {
  final IconData? leadingIcon;
  final String? trailingImage;
  final String title;
  final double? leadingIconSize;

  const MyAppBar({
    super.key,
    this.leadingIcon,
    this.trailingImage,
    required this.title,
    this.leadingIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(leadingIcon),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const Spacer(),
        if (trailingImage != null)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: tsecondaryColor,
                width: 1.5,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: tTextwhiteColor,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: trailingImage!,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(
                    color: tContainerColor,
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error_outline_sharp,
                    color: tBorRedColor,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
