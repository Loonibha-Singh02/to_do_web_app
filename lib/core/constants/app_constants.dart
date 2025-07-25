import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_web_app/core/constants/app_color.dart';

class AppConstants {
  static const String appName = 'To-Do Web App';
  static const double sidebarWidth = 250.0;

  static const borderRadius = BorderRadius.all(Radius.circular(10));

  static const borderRadiusXsm = BorderRadius.all(Radius.circular(5));
  static const borderRadiusSm = BorderRadius.all(Radius.circular(8));
  static const borderRadiusTopBoth = BorderRadius.only(
    topLeft: Radius.circular(10),
    topRight: Radius.circular(10),
  );
  static const borderRadiusBottomBoth = BorderRadius.only(
    bottomLeft: Radius.circular(10),
    bottomRight: Radius.circular(10),
  );
  static const borderRadiusMd = BorderRadius.all(Radius.circular(16));
  static const borderRadiusLg = BorderRadius.all(Radius.circular(20));

  static double padding = 10;
  static EdgeInsets paddingAll = EdgeInsets.all(padding);
  static EdgeInsets paddingAllLg = EdgeInsets.all(16.sp);
  static EdgeInsets paddingAllSm = const EdgeInsets.all(5);
  static EdgeInsets paddingAllLessVertical = EdgeInsets.symmetric(
    vertical: 5,
    horizontal: padding,
  );
  static EdgeInsets paddingHorizontal = EdgeInsets.symmetric(
    horizontal: padding,
  );
  static EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(
    horizontal: 2.sp,
  );
  static EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(
    horizontal: 16.sp,
  );
  static EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: padding);
  static EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: 16.sp);
  static EdgeInsets paddingBottomOnlyLg = EdgeInsets.only(bottom: 200.sp);
  static var marginAllExceptBottom = EdgeInsets.only(
    top: margin,
    left: margin,
    right: margin,
  );

  static double margin = 16;
  static EdgeInsets marginAllsm = EdgeInsets.all(5);
  static EdgeInsets marginAll = EdgeInsets.all(margin);

  static EdgeInsets marginVerticalSm = EdgeInsets.symmetric(vertical: 10);
  static EdgeInsets marginHorizontal = EdgeInsets.symmetric(horizontal: margin);
  static EdgeInsets marginHorizontalSm = EdgeInsets.symmetric(horizontal: 5.sp);
  static EdgeInsets marginOnlyLeft = EdgeInsets.only(left: margin);
  static EdgeInsets marginOnlyRight = EdgeInsets.only(right: margin);
  static EdgeInsets marginOnlyRightSm = EdgeInsets.only(right: 10.sp);
  static EdgeInsets marginVertical = EdgeInsets.symmetric(vertical: margin);
  static EdgeInsets marginVerticalAndHorizontalSm = EdgeInsets.symmetric(
    vertical: margin,
    horizontal: 5.sp,
  );
  static var marginOnlyLeftAndVertical = EdgeInsets.only(
    left: margin,
    top: margin,
    bottom: margin,
  );

  // Border methods that take BuildContext for theme-aware borders
  static BorderSide borderSide(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BorderSide(
      color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      width: 1,
    );
  }

  static Border borderAll(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Border.all(color: isDark ? Colors.grey[800]! : Colors.grey[300]!);
  }

  static Border borderBottom(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Border.symmetric(
      vertical: BorderSide(
        color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      ),
    );
  }

  // Static borders (keep these for backward compatibility)
  static const BorderSide borderSideStatic = BorderSide(
    color: Colors.grey,
    width: 1,
  );
  static var borderSideDark = BorderSide(color: Colors.grey[800]!, width: 1);
  static Color borderColorDark = Colors.grey[800]!;
  static Color borderColor = Colors.grey;

  static BorderSide borderSide300(BuildContext context) =>
      BorderSide(color: Theme.of(context).colorScheme.surfaceDim, width: 1.5);

  static Border borderAllDark = Border.all(color: Colors.grey[800]!);
  static Border borderAllPrimary = Border.all(
    color: const Color.fromARGB(255, 119, 2, 140),
  );
  static Border borderAll200 = Border.all(color: Colors.grey[200]!);
  static Border borderAll100(BuildContext context) => Border.all(
    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
  );

  // Text Themes with RobotoCondensed font
  static const String fontFamily = 'RobotoCondensed';

  static TextTheme lightTextTheme = TextTheme(
    // Display styles
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      color: Colors.black87,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.black87,
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.black87,
    ),

    // Headline styles
    headlineLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 32,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: Colors.black87,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 28,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: Colors.black87,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: Colors.black87,
    ),

    // Title styles
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Colors.black87,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: Colors.black87,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: Colors.black87,
    ),

    // Body styles
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Colors.black87,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Colors.black87,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Colors.black54,
    ),

    // Label styles
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Colors.black87,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.black87,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.black54,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    // Display styles
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Colors.white,
    ),

    // Headline styles
    headlineLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 32,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 28,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: Colors.white,
    ),

    // Title styles
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: Colors.white,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: Colors.white,
    ),

    // Body styles
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Colors.white70,
    ),

    // Label styles
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Colors.white,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.white,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Colors.white70,
    ),
  );

  //light theme
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.onPrimarySwatch,
    primaryColor: AppColor.primarySwatch,
    fontFamily: fontFamily,
    textTheme: lightTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.primarySwatch,
      shape: const RoundedRectangleBorder(borderRadius: borderRadius),
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        color: AppColor.secondarySwatch.shade50,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: Colors.white,
    canvasColor: Colors.white,
  );

  /// Dark theme
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.onDarkSwatch,
    primaryColor: AppColor.secondarySwatch,
    fontFamily: fontFamily,
    textTheme: darkTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.secondarySwatch,
      shape: const RoundedRectangleBorder(borderRadius: borderRadius),
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        color: AppColor.secondarySwatch.shade50,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: AppColor.onDarkSwatch,
    canvasColor: AppColor.onDarkSwatch,
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
  static Icon getBoardIcon(String board, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (board) {
      case 'To Do':
        return Icon(
          Icons.task_alt,
          color: isDark ? Colors.black : Colors.black,
        );
      case 'In Progress':
        return Icon(Icons.work, color: isDark ? Colors.black : Colors.black);
      case 'Completed':
        return Icon(
          Icons.checklist,
          color: isDark ? Colors.black : Colors.black,
        );
      default:
        return Icon(Icons.task_alt);
    }
  }

  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColor.errorSwatch.shade700;
      case 'medium':
        return AppColor.pendingSwatch.shade700;
      case 'low':
        return AppColor.successSwatch.shade700;
      default:
        return Colors.grey;
    }
  }
}
