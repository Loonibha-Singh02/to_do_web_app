import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_web_app/core/widgets/app_spacer_widgets.dart';
import 'package:to_do_web_app/feature/siderbar/models/sidebar_item_model.dart';
import 'package:to_do_web_app/feature/homepage/pages/todo_home_page.dart';
import 'package:to_do_web_app/feature/setting/pages/setting_page.dart';

import 'siderbar/pages/side_bar_widget.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedIndex = 0;

  final sidebarItems = [
    SidebarItemModel(label: 'Home', route: '/home', icon: Icons.home),
    SidebarItemModel(
      label: 'Settings',
      route: '/settings',
      icon: Icons.settings,
    ),
  ];

  Widget getSelectedPage() {
    switch (sidebarItems[selectedIndex].route) {
      case '/home':
        return const TodoWidgets();
      case '/settings':
        return const SettingsPage();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideBarWidget(
            items: sidebarItems,
            selectedRoute: sidebarItems[selectedIndex].route,
            onItemSelected: (route) {
              final index = sidebarItems.indexWhere(
                (item) => item.route == route,
              );
              if (index != -1 && index != selectedIndex) {
                setState(() {
                  selectedIndex = index;
                });
              }
            },
          ),
          AppSpacerWidget(width: 10.spMin),
          Expanded(child: getSelectedPage()),
        ],
      ),
    );
  }
}
