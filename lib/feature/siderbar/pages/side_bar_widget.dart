import 'package:flutter/material.dart';
import 'package:to_do_web_app/core/constants/app_color.dart';
import 'package:to_do_web_app/core/constants/app_constants.dart';
import 'package:to_do_web_app/feature/siderbar/models/sidebar_item_model.dart';

class SideBarWidget extends StatefulWidget {
  final List<SidebarItemModel> items;
  final ValueChanged<String>? onItemSelected; // optional navigation callback
  final String selectedRoute;

  const SideBarWidget({
    super.key,
    required this.items,
    required this.selectedRoute,
    this.onItemSelected,
  });

  @override
  State<SideBarWidget> createState() => _SidebarWidgetsState();
}

class _SidebarWidgetsState extends State<SideBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: AppColor.primarySwatch,
          borderRadius: AppConstants.borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App title
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                AppConstants.appName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(color: Colors.white54),

            // Sidebar items
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final isSelected = item.route == widget.selectedRoute;

                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: ListTile(
                      selected: isSelected,
                      leading: item.icon != null
                          ? Icon(
                              item.icon,
                              color: isSelected ? Colors.white : Colors.white70,
                            )
                          : null,
                      title: Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        if (widget.onItemSelected != null) {
                          widget.onItemSelected!(item.route);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
