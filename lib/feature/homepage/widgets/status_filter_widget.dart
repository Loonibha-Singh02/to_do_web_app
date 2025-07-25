import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_web_app/core/constants/app_color.dart';
import 'package:to_do_web_app/core/widgets/app_spacer_widgets.dart';
import 'package:to_do_web_app/feature/homepage/providers/task_provider.dart';

class StatusFilterWidget extends ConsumerWidget {
  const StatusFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(selectedStatusesProvider);
    final filterActions = ref.watch(simpleFilterActionsProvider);

    return PopupMenuButton<String>(
      tooltip: 'Filter Tasks by Status',
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
                'Filter by Status',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (selectedStatus.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    filterActions.clearStatusFilters();
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
        // FIXED: Use correct status values that match your enum
        _buildStatusMenuItem(
          'To Do',
          Colors.red,
          selectedStatus,
          filterActions,
        ),
        _buildStatusMenuItem(
          'In Progress',
          Colors.orange,
          selectedStatus,
          filterActions,
        ),
        _buildStatusMenuItem(
          'Completed',
          Colors.green,
          selectedStatus,
          filterActions,
        ),
      ],
      child: Row(
        children: [
          Icon(Icons.filter_list, color: Colors.white, size: 15),
          Text(
            'Status',
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

  PopupMenuItem<String> _buildStatusMenuItem(
    String status,
    Color color,
    Set<String> selectedStatus,
    SimpleFilterActions filterActions,
  ) {
    final isSelected = selectedStatus.contains(status);

    return PopupMenuItem<String>(
      value: status,
      onTap: () => filterActions.toggleStatus(status),
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
            status,
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
