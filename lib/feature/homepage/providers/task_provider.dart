// lib/feature/task/providers/task_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_web_app/feature/firebase/services/firebase_todo_services.dart';
import 'package:to_do_web_app/feature/firebase/models/task_model.dart';

// Provider for Firebase service
final firebaseTodoServiceProvider = Provider<FirebaseTodoServices>((ref) {
  return FirebaseTodoServices();
});

// Provider for all tasks stream
final tasksStreamProvider = StreamProvider<List<TaskModel>>((ref) {
  final service = ref.watch(firebaseTodoServiceProvider);
  return service.getTasks();
});

// Provider for tasks by status
final tasksByStatusProvider = StreamProvider.family<List<TaskModel>, String>((
  ref,
  status,
) {
  final service = ref.watch(firebaseTodoServiceProvider);
  return service.getTasksByStatus(status);
});

// Provider for todo tasks
final todoTasksProvider = StreamProvider<List<TaskModel>>((ref) {
  final service = ref.watch(firebaseTodoServiceProvider);
  final selectedPriorities = ref.watch(selectedPrioritiesProvider);

  return service.getTasksByStatus('To Do').map((tasks) {
    return filterTasks(tasks, selectedPriorities, {});
  });
});

// Provider for in progress tasks
final inProgressTasksProvider = StreamProvider<List<TaskModel>>((ref) {
  final service = ref.watch(firebaseTodoServiceProvider);
  final selectedPriorities = ref.watch(selectedPrioritiesProvider);

  return service.getTasksByStatus('In Progress').map((tasks) {
    return filterTasks(tasks, selectedPriorities, {});
  });
});

// Provider for completed tasks
final completedTasksProvider = StreamProvider<List<TaskModel>>((ref) {
  final service = ref.watch(firebaseTodoServiceProvider);
  final selectedPriorities = ref.watch(selectedPrioritiesProvider);

  return service.getTasksByStatus('Completed').map((tasks) {
    return filterTasks(tasks, selectedPriorities, {});
  });
});

// Task actions provider
final taskActionsProvider = Provider<TaskActions>((ref) {
  final service = ref.watch(firebaseTodoServiceProvider);
  return TaskActions(service);
});

class TaskActions {
  final FirebaseTodoServices _service;

  TaskActions(this._service);

  Future<void> createTask({
    required String title,
    required String status,
    DateTime? startDate,
    String? desc,
    DateTime? dueDate,
    String? priority,
  }) async {
    await _service.createTask(
      title: title,
      status: status,
      startDate: startDate,
      desc: desc,
      dueDate: dueDate,
      priority: priority,
    );
  }

  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    await _service.updateTaskStatus(taskId, newStatus);
  }

  Future<void> updateTask({
    required String taskId,
    String? title,
    String? status,
    DateTime? startDate,
    DateTime? dueDate,
    String? desc,
    String? priority,
  }) async {
    await _service.updateTask(
      taskId: taskId,
      title: title,
      status: status,
      startDate: startDate,
      desc: desc,
      dueDate: dueDate,
      priority: priority,
    );
  }

  Future<void> deleteTask(String taskId) async {
    await _service.deleteTask(taskId);
  }
}

// Simple filter state
final selectedPrioritiesProvider = StateProvider<Set<String>>((ref) => {});
final selectedStatusesProvider = StateProvider<Set<String>>((ref) => {});

// Helper function to filter tasks
List<TaskModel> filterTasks(
  List<TaskModel> tasks,
  Set<String> priorities,
  Set<String> statuses,
) {
  var filteredTasks = tasks;

  // Filter by priority if any selected
  if (priorities.isNotEmpty) {
    filteredTasks = filteredTasks.where((task) {
      return task.priority != null && priorities.contains(task.priority);
    }).toList();
  }

  // Filter by status if any selected (for overall filtering)
  if (statuses.isNotEmpty) {
    filteredTasks = filteredTasks.where((task) {
      return statuses.contains(task.status);
    }).toList();
  }

  return filteredTasks;
}

// Simple filter actions
class SimpleFilterActions {
  final Ref ref;
  SimpleFilterActions(this.ref);

  void togglePriority(String priority) {
    final current = ref.read(selectedPrioritiesProvider);
    final updated = Set<String>.from(current);

    if (updated.contains(priority)) {
      updated.remove(priority);
    } else {
      updated.add(priority);
    }

    ref.read(selectedPrioritiesProvider.notifier).state = updated;
  }

  void clearPriorityFilters() {
    ref.read(selectedPrioritiesProvider.notifier).state = {};
  }

  void clearAllFilters() {
    ref.read(selectedPrioritiesProvider.notifier).state = {};
    ref.read(selectedStatusesProvider.notifier).state = {};
  }

  // Status filter actions (same as priority)
  void toggleStatus(String status) {
    final current = ref.read(selectedStatusesProvider);
    final updated = Set<String>.from(current);

    if (updated.contains(status)) {
      updated.remove(status);
    } else {
      updated.add(status);
    }

    ref.read(selectedStatusesProvider.notifier).state = updated;
  }

  void clearStatusFilters() {
    ref.read(selectedStatusesProvider.notifier).state = {};
  }
}

final simpleFilterActionsProvider = Provider((ref) => SimpleFilterActions(ref));
