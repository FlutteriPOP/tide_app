import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final double? radius;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final BoxDecoration? decoration;

  const MyContainer({
    super.key,
    this.height,
    this.width,
    this.color,
    this.radius,
    this.child,
    this.alignment,
    this.padding,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: color,
      alignment: alignment,
      padding: padding,
      decoration: decoration,
      child: child,
    );
  }
}
