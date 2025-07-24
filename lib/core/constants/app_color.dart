import 'package:flutter/material.dart';

class AppColor {
  // Primary colors
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF465C88, // Primary 500
    {
      50: Color(0xFFE8EBF3), // Primary 50
      100: Color(0xFFC2C9D9), // Primary 100
      200: Color(0xFF9CA1BE), // Primary 200
      300: Color(0xFF767A9F), // Primary 300
      400: Color(0xFF5A5E88), // Primary 400
      500: Color(0xFF465C88), // Primary 500
      600: Color(0xFF3B4D7A), // Primary 600
      700: Color(0xFF2F3E6C), // Primary 700
      800: Color(0xFF24305E), // Primary 800
      900: Color(0xFF18224F), // Primary 900
    },
  );

  // Secondary colors
  static const MaterialColor secondarySwatch = MaterialColor(
    0xFF748DAE, // Secondary 500
    {
      50: Color(0xFFE8EDF4), // Secondary 50
      100: Color(0xFFC2C9E0), // Secondary 100
      200: Color(0xFF9CA5CC), // Secondary 200
      300: Color(0xFF7681B8), // Secondary 300
      400: Color(0xFF5A5DA4), // Secondary 400
      500: Color(0xFF748DAE), // Secondary 500
      600: Color(0xFF3B4D7A), // Secondary 600
      700: Color(0xFF2F3E6C), // Secondary 700
      800: Color(0xFF24305E), // Secondary 800
      900: Color(0xFF18224F), // Secondary 900
    },
  );

  static const MaterialColor errorSwatch = MaterialColor(
    0xFFB00020, // Error 500
    {
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(0xFFB00020),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB00020),
    },
  );

  // Success colors
  static const MaterialColor successSwatch = MaterialColor(
    0xFF00C853, // Success 500
    {
      50: Color(0xFFF6FEF9),
      100: Color(0xFFD1FADF),
      200: Color(0xFFA5D6A7),
      300: Color(0xFF81C784),
      400: Color(0xFF66BB6A),
      500: Color(0xFF00C853),
      600: Color(0xFF039855),
      700: Color(0xFF027A48),
      800: Color(0xFF2E7D32),
      900: Color(0xFF1B5E20),
    },
  );

  //pending colors
  static const MaterialColor pendingSwatch = MaterialColor(
    0xFFFF894F, // Pending 500
    {
      50: Color(0xFFFFF3E0),
      100: Color(0xFFFFE0B2),
      200: Color(0xFFFFCC80),
      300: Color(0xFFFFB74D),
      400: Color(0xFFFFA726),
      500: Color(0xFFFF894F),
      600: Color(0xFFFF6F00),
      700: Color(0xFFFF5722),
      800: Color(0xFFFF3D00),
      900: Color(0xFFE65100),
    },
  );

  // On Primary colors
  static const MaterialColor onPrimarySwatch = MaterialColor(
    0xFFFFFFFF, // On Primary 500
    {
      50: Color(0xFFFFFFFF),
      100: Color(0xFFF0F0F0),
      200: Color(0xFFE0E0E0),
      300: Color(0xFFD0D0D0),
      400: Color(0xFFC0C0C0),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFA0A0A0),
      700: Color(0xFF909090),
      800: Color(0xFF808080),
      900: Color(0xFF707070),
    },
  );

  static const MaterialColor onDarkSwatch = MaterialColor(
    0xFF2A2A2A, // Light color suitable for contrast against the tertiarySwatch
    {
      25: Color(0xFF1A1A1A), // Very dark, near black
      50: Color(0xFF2A2A2A), // Darker grey
      100: Color(0xFF3A3A3A), // Dark grey
      200: Color(0xFF4A4A4A), // Mid-dark grey
      300: Color(0xFF5A5A5A), // Dark grey
      400: Color(0xFF6A6A6A), // Slightly lighter grey
      500: Color(0xFF7A7A7A), // Base contrast color for tertiarySwatch
      600: Color(0xFF8A8A8A), // Lighter grey
      700: Color(0xFF9A9A9A), // Light grey suitable for text
      800: Color(0xFFAAAAAA), // Lighter grey, good for secondary text
      900: Color(0xFFCACACA), // Lightest grey
    },
  );
}
