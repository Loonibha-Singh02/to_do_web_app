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
  return service.getTasksByStatus('To Do');
});

// Provider for in progress tasks
final inProgressTasksProvider = StreamProvider<List<TaskModel>>((ref) {
  final service = ref.watch(firebaseTodoServiceProvider);
  return service.getTasksByStatus('In Progress');
});

// Provider for completed tasks
final completedTasksProvider = StreamProvider<List<TaskModel>>((ref) {
  final service = ref.watch(firebaseTodoServiceProvider);
  return service.getTasksByStatus('Completed');
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
