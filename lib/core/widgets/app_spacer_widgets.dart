import 'package:flutter/material.dart';

class AppSpacerWidget extends StatelessWidget {
  const AppSpacerWidget({super.key, this.height = 10, this.width});

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width);
  }

  factory AppSpacerWidget.sectionSpacer() {
    return const AppSpacerWidget(height: 30);
  }
}
