import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_web_app/core/constants/app_color.dart';
import 'package:to_do_web_app/core/constants/app_constants.dart';
import 'package:to_do_web_app/core/enums/active_navbar_enum.dart';

class MobileSidebarWidget extends StatelessWidget {
  const MobileSidebarWidget({
    super.key,
    required this.activeNavbarItem,
    this.onItemSelected,
  });

  final ActiveNavbarEnum activeNavbarItem;
  final Function(String route)? onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppConstants.darkTheme,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColor.primarySwatch),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 50, color: AppColor.secondarySwatch),
                  SizedBox(height: 10),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Admin Dashboard",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildNavItem(
              context: context,
              icon: Icons.home,
              title: 'Home',
              route: '/home',
              isActive: activeNavbarItem == ActiveNavbarEnum.home,
            ),
            _buildNavItem(
              context: context,
              icon: Icons.settings,
              title: 'Settings',
              route: '/settings',
              isActive: activeNavbarItem == ActiveNavbarEnum.settings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required bool isActive,
  }) {
    // Only log when item is actually active - this reduces unnecessary logs
    if (isActive) {
      log("Currently Active: $title");
    }

    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? AppColor.onPrimarySwatch : AppColor.secondarySwatch,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? AppColor.onPrimarySwatch : AppColor.secondarySwatch,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isActive,
      onTap: () {
        log("Tapped: $title -> $route"); // Log the actual tap event
        Navigator.of(context).pop(); // Close drawer
        onItemSelected?.call(route);
      },
    );
  }
}
