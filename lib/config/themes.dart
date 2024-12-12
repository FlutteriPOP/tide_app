import 'package:flutter/material.dart';

import 'colors.dart';

const tsatoshi = 'Satoshi';
const tbSatoshi = 'Satoshi-Bold';
const tmSatoshi = 'Satoshi-Medium';

ThemeData customTheme = ThemeData(
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamily: tsatoshi,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: tTextblackColor,
    ),
    bodyLarge: TextStyle(
      fontFamily: tsatoshi,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: tTextblackColor,
    ),
    bodyMedium: TextStyle(
      fontFamily: tsatoshi,
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: tTextblackColor,
    ),
    bodySmall: TextStyle(
      fontFamily: tsatoshi,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: tFontcolor,
    ),
    headlineMedium: TextStyle(
      fontFamily: tsatoshi,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: tTextblackColor,
    ),
    headlineSmall: TextStyle(
      fontFamily: tsatoshi,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: tTextblackColor,
    ),
    titleLarge: TextStyle(
      fontFamily: tsatoshi,
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: tTextblackColor,
    ),
  ),
);
