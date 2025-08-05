import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_web_app/core/widgets/app_spacer_widgets.dart';
import 'package:to_do_web_app/core/widgets/responsive_widget.dart';
import 'package:to_do_web_app/core/enums/active_navbar_enum.dart';
import 'package:to_do_web_app/feature/siderbar/models/sidebar_item_model.dart';
import 'package:to_do_web_app/feature/siderbar/pages/side_bar_widget.dart';
import 'package:to_do_web_app/feature/homepage/pages/todo_home_page.dart';
import 'package:to_do_web_app/feature/setting/pages/setting_page.dart';

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

  // Get current active navbar enum based on selected index
  ActiveNavbarEnum get currentActiveNavbar {
    switch (sidebarItems[selectedIndex].route) {
      case '/home':
        return ActiveNavbarEnum.home;
      case '/settings':
        return ActiveNavbarEnum.settings;
      default:
        return ActiveNavbarEnum.home;
    }
  }

  Widget getSelectedPage() {
    switch (sidebarItems[selectedIndex].route) {
      case '/home':
        return TodoHomePage(
          key: const ValueKey('home_page'),
          activeNavbarItem: currentActiveNavbar,
          onNavItemSelected: _onItemSelected,
        );
      case '/settings':
        return SettingsPage(
          key: const ValueKey('settings_page'),
          activeNavbarItem: currentActiveNavbar,
          onNavItemSelected: _onItemSelected,
        );
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  void _onItemSelected(String route) {
    final index = sidebarItems.indexWhere((item) => item.route == route);
    //The route was found in the sidebar items and The found item is different from currently selected
    if (index != -1 && index != selectedIndex) {
      setState(() {
        selectedIndex = index;
      });
    } else {
      SnackBar(content: Text('No route defined for $route'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedPage = getSelectedPage();

    return ResponsiveWidget(
      // Mobile: Full-screen page with drawer
      mobile: selectedPage,

      // Tablet: Full-screen page with drawer
      tablet: selectedPage,

      // Desktop: Sidebar + page layout
      desktop: Scaffold(
        body: Row(
          children: [
            SideBarWidget(
              items: sidebarItems,
              selectedRoute: sidebarItems[selectedIndex].route,
              onItemSelected: _onItemSelected,
            ),
            AppSpacerWidget(width: 10.spMin),
            Expanded(child: selectedPage),
          ],
        ),
      ),
    );
  }
}
