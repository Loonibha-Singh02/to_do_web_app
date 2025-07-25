import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_web_app/feature/firebase/models/task_model.dart';
import 'package:to_do_web_app/feature/homepage/providers/task_provider.dart';

class BoardController {
  late final AppFlowyBoardController controller;
  final WidgetRef ref;

  // Track which groups have input forms open
  final Set<String> _groupsWithInputForms = <String>{};

  // Track which tasks are being edited
  final Map<String, TaskModel> _tasksBeingEdited = <String, TaskModel>{};

  // Track the currently dragged item
  TaskItem? _currentlyDraggedItem;

  BoardController(this.ref) {
    controller = AppFlowyBoardController(
      onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
        debugPrint('Move group from $fromIndex to $toIndex');
      },
      onMoveGroupItem: (groupId, fromIndex, toIndex) {
        debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
      },
      onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
        _handleTaskMove(fromGroupId, fromIndex, toGroupId, toIndex);
      },
    );
  }

  void initializeBoard() {
    controller.addGroup(
      AppFlowyGroupData(id: "To Do", name: "To Do", items: []),
    );

    controller.addGroup(
      AppFlowyGroupData(id: "In Progress", name: "In Progress", items: []),
    );

    controller.addGroup(
      AppFlowyGroupData(id: "Completed", name: "Completed", items: []),
    );
  }

  void updateGroupWithTasks(String groupId, List<TaskModel> tasks) {
    final group = controller.getGroupController(groupId);
    if (group != null) {
      // Clear all items first
      while (group.items.isNotEmpty) {
        group.removeAt(0);
      }

      // Add only TaskItems - no other items in the group data
      for (var task in tasks) {
        group.add(TaskItem(task));
      }
    }
  }

  void _handleTaskMove(
    String fromGroupId,
    int fromIndex,
    String toGroupId,
    int toIndex,
  ) {
    TaskItem? taskToUpdate;
    // Method 1: Use tracked dragged item
    if (_currentlyDraggedItem != null) {
      taskToUpdate = _currentlyDraggedItem!;
      _currentlyDraggedItem = null;
    }
    // Method 2: Get item from destination position
    else {
      final toGroup = controller.getGroupController(toGroupId);
      if (toGroup != null && toIndex < toGroup.items.length) {
        final item = toGroup.items[toIndex];
        if (item is TaskItem) {
          taskToUpdate = item;
        }
      }
    }
    // Update task status if we found the task
    if (taskToUpdate != null) {
      final taskActions = ref.read(taskActionsProvider);
      taskActions.updateTaskStatus(taskToUpdate.task.id, toGroupId).catchError((
        error,
      ) {
        debugPrint('Error updating task status: $error');
      });
    } else {
      debugPrint('Could not determine which task was moved');
    }
  }

  void addNewTaskToGroup(String groupId, TaskModel task) {
    final group = controller.getGroupController(groupId);
    if (group != null) {
      group.add(TaskItem(task));
    }
  }

  void showAddTaskForm(String groupId) {
    _groupsWithInputForms.add(groupId);
    _currentlyDraggedItem = null;
  }

  void cancelAddTask(String groupId) {
    _groupsWithInputForms.remove(groupId);
    _currentlyDraggedItem = null;
  }

  bool hasInputForm(String groupId) {
    return _groupsWithInputForms.contains(groupId);
  }

  Future<void> saveNewTask({
    required String groupId,
    required String title,
    DateTime? startDate,
    DateTime? dueDate,
    String? desc,
    String? priority,
  }) async {
    if (title.trim().isEmpty) return;

    try {
      final taskActions = ref.read(taskActionsProvider);
      await taskActions.createTask(
        title: title.trim(),
        status: groupId,
        startDate: startDate,
        desc: desc,
        dueDate: dueDate,
        priority: priority,
      );

      // Remove the input form
      cancelAddTask(groupId);
    } catch (error) {
      debugPrint('Error creating task: $error');
      rethrow;
    }
  }

  // EDIT MODE METHODS
  void startEditingTask(TaskModel task) {
    _tasksBeingEdited[task.id] = task;
  }

  void cancelEditTask(String taskId) {
    _tasksBeingEdited.remove(taskId);
    _currentlyDraggedItem = null;
  }

  bool isTaskBeingEdited(String taskId) {
    return _tasksBeingEdited.containsKey(taskId);
  }

  TaskModel? getTaskBeingEdited(String taskId) {
    return _tasksBeingEdited[taskId];
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final taskActions = ref.read(taskActionsProvider);
      await taskActions.deleteTask(taskId);
    } catch (error) {
      debugPrint('Error deleting task: $error');
      rethrow;
    }
  }

  Future<void> updateTask({
    required String taskId,
    required String title,
    DateTime? startDate,
    DateTime? dueDate,
    String? desc,
    String? priority,
  }) async {
    if (title.trim().isEmpty) return;

    try {
      final taskActions = ref.read(taskActionsProvider);
      await taskActions.updateTask(
        taskId: taskId,
        title: title.trim(),
        startDate: startDate,
        desc: desc,
        dueDate: dueDate,
        priority: priority,
      );

      // Remove from editing state
      cancelEditTask(taskId);
    } catch (error) {
      debugPrint('Error updating task: $error');
      rethrow;
    }
  }

  void dispose() {
    controller.dispose();
  }
}

// Custom item classes with drag control
class TaskItem extends AppFlowyGroupItem {
  final TaskModel task;

  TaskItem(this.task);

  @override
  String get id => task.id;

  bool get canDrag => true;
}
