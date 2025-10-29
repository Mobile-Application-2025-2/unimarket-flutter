import 'package:flutter/material.dart';

abstract final class AppColors {
  static const yellow = Color(0xFFFFC843);
  static const intermediateYellow = Color(0xFFECAB0F);
  static const darkYellow = Color(0xFFD09306);
  static const grey = Color(0xFFA1A4B2);
  static const white = Color(0xFFF6F1FB);
  static const black = Color(0xFF000000);

  static const whiteTransparent = Color(
    0x4DFFFFFF,
  );
  static const blackTransparent = Color(0x4D000000);

    static const lightColorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.yellow,
      onPrimary: AppColors.white,
      secondary: AppColors.yellow,
      onSecondary: AppColors.white,

      surface: Colors.white,
      onSurface: AppColors.black,

      error: Colors.white,
      onError: Colors.red,
    );
}