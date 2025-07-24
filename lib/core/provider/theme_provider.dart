import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_web_app/core/constants/app_constants.dart';

// A provider for the current theme mode (light/dark)
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

// A provider for the current theme data based on toggled theme mode
final isDarkModeProvider = Provider<bool>((ref) {
  final mode = ref.watch(themeModeProvider);
  if (mode == ThemeMode.system) {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }
  return mode == ThemeMode.dark;
});

final themeDataProvider = Provider<ThemeData>((ref) {
  final isDarkMode = ref.watch(isDarkModeProvider);
  return isDarkMode ? AppConstants.darkTheme : AppConstants.lightTheme;
});