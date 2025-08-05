import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_web_app/core/provider/theme_provider.dart';
import 'package:to_do_web_app/core/enums/active_navbar_enum.dart';
import 'package:to_do_web_app/core/utils/size_utils.dart';
import 'package:to_do_web_app/feature/siderbar/pages/mobile_side_bar_widget.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({
    super.key,
    required this.activeNavbarItem,
    required this.onNavItemSelected,
  });

  final ActiveNavbarEnum activeNavbarItem;
  final Function(String route) onNavItemSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final isDesktop = SizeUtils.getLayoutMode() == LayoutMode.desktop;

    return Scaffold(
      // Only show drawer on mobile and tablet
      drawer: isDesktop
          ? null
          : MobileSidebarWidget(
              activeNavbarItem: activeNavbarItem,
              onItemSelected: onNavItemSelected,
            ),
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Dark Mode'),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}