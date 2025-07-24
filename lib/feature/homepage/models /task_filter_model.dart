import 'package:to_do_web_app/feature/firebase/models/task_model.dart';

class TaskFilter {
  final String? priority; // e.g. 'High', 'Medium', 'Low'
  final String? status;   // e.g. 'To Do', 'In Progress', 'Completed'

  const TaskFilter({this.priority, this.status});

  TaskFilter copyWith({String? priority, String? status}) {
    return TaskFilter(
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }

  bool matches(TaskModel task) {
    final matchesPriority = priority == null || task.priority?.toLowerCase() == priority!.toLowerCase();
    final matchesStatus = status == null || task.status == status;
    return matchesPriority && matchesStatus;
  }
}
