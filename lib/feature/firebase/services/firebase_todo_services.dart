import 'package:firebase_database/firebase_database.dart';
import 'package:to_do_web_app/feature/firebase/models/task_model.dart';

class FirebaseTodoServices {
  final DatabaseReference _tasksRef = FirebaseDatabase.instance.ref().child(
    'tasks',
  );

  /// Create a new task
  Future<TaskModel> createTask({
    required String title,
    required String status,
    DateTime? startDate,
    DateTime? dueDate,
    String? priority,
    String? desc,
  }) async {
    try {
      final newRef = _tasksRef.push();
      final task = TaskModel(
        id: newRef.key!,
        title: title,
        status: status,
        startDate: startDate,
        dueDate: dueDate,
        priority: priority,
        desc: desc,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await newRef.set(task.toMap());
      return task;
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  /// Listen to all tasks (Realtime)
  Stream<List<TaskModel>> getTasks() {
    return _tasksRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return [];

      return data.entries.map((entry) {
        final taskMap = Map<String, dynamic>.from(entry.value);
        return TaskModel.fromMap(taskMap);
      }).toList();
    });
  }

  /// Filter by status (client-side)
  Stream<List<TaskModel>> getTasksByStatus(String status) {
    return getTasks().map((allTasks) {
      return allTasks.where((task) => task.status == status).toList();
    });
  }

  /// Update task
  Future<void> updateTask({
    required String taskId,
    String? title,
    String? status,
    DateTime? startDate,
    DateTime? dueDate,
    String? priority,
    String? desc,
  }) async {
    try {
      final updateData = {'updatedAt': DateTime.now().toIso8601String()};

      if (title != null) updateData['title'] = title;
      if (status != null) updateData['status'] = status;
      if (startDate != null) {
        updateData['startDate'] = startDate.toIso8601String();
      }
      if (dueDate != null) updateData['dueDate'] = dueDate.toIso8601String();
      if (priority != null) updateData['priority'] = priority;
      if (desc != null) updateData['desc'] = desc;

      await _tasksRef.child(taskId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  /// Update status only
  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    await _tasksRef.child(taskId).update({
      'status': newStatus,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  /// Delete task
  Future<void> deleteTask(String taskId) async {
    await _tasksRef.child(taskId).remove();
  }
}
