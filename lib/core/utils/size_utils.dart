import 'package:flutter_screenutil/flutter_screenutil.dart';

enum LayoutMode {
  mobile,
  tablet,
  desktop,
}

class SizeUtils {
  static LayoutMode getLayoutMode() {
    // get size from screen utils package
    final double width = 1.sw;
    if (width < 600) {
      return LayoutMode.mobile;
    } else if (width < 1200) {
      return LayoutMode.tablet;
    } else {
      return LayoutMode.desktop;
    }
  }
}
