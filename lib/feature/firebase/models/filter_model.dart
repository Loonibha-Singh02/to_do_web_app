import 'package:to_do_web_app/core/enums/sort_by_enum.dart';
import 'package:to_do_web_app/core/enums/task_priority_enum.dart';
import 'package:to_do_web_app/core/enums/task_status_enum.dart';

class FilterOptions {
  final Set<TaskPriorityEnum> priorities;
  final Set<TaskStatusEnum> statuses;
  final DateTime? startDateFilter;
  final DateTime? endDateFilter;

  const FilterOptions({
    this.priorities = const {},
    this.statuses = const {},
    this.startDateFilter,
    this.endDateFilter,
  });

  FilterOptions copyWith({
    Set<TaskPriorityEnum>? priorities,
    Set<TaskStatusEnum>? statuses,
    DateTime? startDateFilter,
    DateTime? endDateFilter,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return FilterOptions(
      priorities: priorities ?? this.priorities,
      statuses: statuses ?? this.statuses,
      startDateFilter: clearStartDate
          ? null
          : (startDateFilter ?? this.startDateFilter),
      endDateFilter: clearEndDate
          ? null
          : (endDateFilter ?? this.endDateFilter),
    );
  }

  bool get hasActiveFilters {
    return priorities.isNotEmpty ||
        statuses.isNotEmpty ||
        startDateFilter != null ||
        endDateFilter != null;
  }
}

class SortOptions {
  final SortByEnum sortBy;

  const SortOptions({this.sortBy = SortByEnum.createdDate});

  SortOptions copyWith({SortByEnum? sortBy}) {
    return SortOptions(sortBy: sortBy ?? this.sortBy);
  }
}
