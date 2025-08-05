import 'package:flutter/material.dart';
import 'package:to_do_web_app/core/utils/size_utils.dart';

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Phone, Tablet, Desktop
        switch (SizeUtils.getLayoutMode()) {
          case LayoutMode.mobile:
            return mobile;
          case LayoutMode.tablet:
            return tablet;
          case LayoutMode.desktop:
            return desktop;
        }
      },
    );
  }
}
