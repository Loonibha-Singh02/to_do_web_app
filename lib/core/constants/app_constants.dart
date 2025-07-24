import 'package:flutter/material.dart';
import 'package:to_do_web_app/core/constants/app_color.dart';

class AppConstants {
  static const String appName = 'To-Do Web App';
  static const double sidebarWidth = 250.0;

  static const borderRadius = BorderRadius.all(Radius.circular(10));

  //light theme
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.onPrimarySwatch,
    primaryColor: AppColor.primarySwatch,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.primarySwatch,
      shape: const RoundedRectangleBorder(
        borderRadius: AppConstants.borderRadius,
      ),
      titleTextStyle: TextStyle(
        color: AppColor.secondarySwatch.shade50,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  //dark theme
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.onDarkSwatch,
    primaryColor: AppColor.secondarySwatch,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.secondarySwatch,
      shape: const RoundedRectangleBorder(
        borderRadius: AppConstants.borderRadius,
      ),
      titleTextStyle: TextStyle(
        color: AppColor.secondarySwatch,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static Color getBoardColor(String board) {
    switch (board) {
      case 'To Do':
        return AppColor.pendingSwatch.shade100;
      case 'In Progress':
        return AppColor.errorSwatch.shade100;
      case 'Completed':
        return AppColor.successSwatch.shade100;
      default:
        return Colors.grey;
    }
  }

  //icon for board
  static Icon getBoardIcon(String board) {
    switch (board) {
      case 'To Do':
        return const Icon(Icons.task_alt);
      case 'In Progress':
        return const Icon(Icons.work);
      case 'Completed':
        return const Icon(Icons.checklist);
      default:
        return const Icon(Icons.task_alt);
    }
  }
}
