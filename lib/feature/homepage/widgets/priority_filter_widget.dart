import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_web_app/core/constants/app_color.dart';
import 'package:to_do_web_app/core/widgets/app_spacer_widgets.dart';
import 'package:to_do_web_app/feature/homepage/providers/task_provider.dart';

class PriorityFilterWidget extends ConsumerWidget {
  const PriorityFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPriorities = ref.watch(selectedPrioritiesProvider);
    final filterActions = ref.watch(simpleFilterActionsProvider);

    return PopupMenuButton<String>(
      tooltip: 'Filter Tasks',
      color: Colors.white,
      offset: const Offset(0, 40),
      itemBuilder: (context) => [
        // Title
        PopupMenuItem<String>(
          enabled: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter by Priority',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (selectedPriorities.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    filterActions.clearPriorityFilters();
                  },
                  child: Icon(
                    Icons.clear,
                    color: AppColor.errorSwatch.shade700,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
        const PopupMenuDivider(),

        // High Priority
        _buildPriorityMenuItem(
          'High',
          Colors.red,
          selectedPriorities,
          filterActions,
        ),

        // Medium Priority
        _buildPriorityMenuItem(
          'Medium',
          Colors.orange,
          selectedPriorities,
          filterActions,
        ),

        // Low Priority
        _buildPriorityMenuItem(
          'Low',
          Colors.green,
          selectedPriorities,
          filterActions,
        ),
      ],
      child: Row(
        children: [
          Icon(Icons.filter_list, color: Colors.white, size: 15),
          Text(
            'Priority',
            style: TextStyle(
              fontSize: 15.spMin,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPriorityMenuItem(
    String priority,
    Color color,
    Set<String> selectedPriorities,
    SimpleFilterActions filterActions,
  ) {
    final isSelected = selectedPriorities.contains(priority);

    return PopupMenuItem<String>(
      value: priority,
      onTap: () => filterActions.togglePriority(priority),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_box : Icons.check_box_outline_blank,
            color: isSelected ? color : Colors.grey.shade400,
            size: 20,
          ),
          const AppSpacerWidget(width: 12),
          Icon(Icons.flag, color: color, size: 16),
          const AppSpacerWidget(width: 8),
          Text(
            priority,
            style: TextStyle(
              color: isSelected ? color : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
