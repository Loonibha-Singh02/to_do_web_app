import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_web_app/core/constants/app_color.dart';

import '../constants/app_constants.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    this.onPressed,
    required this.label,
    this.isLoading = false,
    this.fontsize,
    this.height = 40,
    this.width = double.infinity,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.labelColor,
  });
  final Function()? onPressed;
  final String label;
  final Color? labelColor;
  final bool isLoading;
  final double? fontsize;
  final double height;
  final double width;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final WidgetStateProperty<EdgeInsets>? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FilledButton(
        onHover: (value) {
          if (value) {
            foregroundColor ?? Colors.transparent;
          }
        },
        style: ButtonStyle(
          padding: padding,
          backgroundColor: onPressed != null
              ? WidgetStateProperty.all(
                  backgroundColor ?? AppColor.primarySwatch,
                )
              : null,
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: AppConstants.borderRadius,
            ),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? CupertinoActivityIndicator(
                color: foregroundColor ?? AppColor.primarySwatch.shade100,
              )
            : Text(
                label,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: labelColor ?? Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                ),
              ),
      ),
    );
  }

  // Icon Button
  static Widget icon({
    required String label,
    required IconData icon,
    Function()? onPressed,
    bool isLoading = false,
    double? fontsize,
    double height = 50,
    double width = double.infinity,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? iconColor,
    WidgetStateProperty<EdgeInsets>? padding,
    final Color? labelColor,
    required BuildContext context,
    // New border properties
    BorderSide? borderSide,
    Color? borderColor,
    BorderRadius? borderRadius,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: FilledButton.icon(
        onHover: (value) {
          if (value) {
            foregroundColor ?? Colors.transparent;
          }
        },
        style: ButtonStyle(
          padding: padding,
          splashFactory: NoSplash.splashFactory,
          backgroundColor: onPressed != null
              ? WidgetStateProperty.all(
                  backgroundColor ?? AppColor.primarySwatch,
                )
              : null,
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: borderRadius ?? AppConstants.borderRadius,
              side:
                  borderSide ??
                  (borderColor != null
                      ? BorderSide(color: borderColor)
                      : BorderSide.none),
            ),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        icon: Icon(
          icon,
          color: iconColor ?? AppColor.primarySwatch.shade100,
          size: 20.spMin,
        ),
        label: isLoading
            ? CupertinoActivityIndicator(
                color: foregroundColor ?? AppColor.primarySwatch.shade100,
              )
            : Text(
                label,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: labelColor ?? Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                ),
              ),
      ),
    );
  }
}
