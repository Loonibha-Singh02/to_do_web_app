// lib/feature/task/controllers/board_controller.dart
import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_web_app/feature/firebase/models/task_model.dart';
import 'package:to_do_web_app/feature/homepage/providers/task_provider.dart';

class BoardController {
  late final AppFlowyBoardController controller;
  final WidgetRef ref;

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
    // Initialize empty groups
    controller.addGroup(
      AppFlowyGroupData(id: "To Do", name: "To Do", items: [AddButtonItem()]),
    );

    controller.addGroup(
      AppFlowyGroupData(
        id: "In Progress",
        name: "In Progress",
        items: [AddButtonItem()],
      ),
    );

    controller.addGroup(
      AppFlowyGroupData(
        id: "Completed",
        name: "Completed",
        items: [AddButtonItem()],
      ),
    );
  }

  void updateGroupWithTasks(String groupId, List<TaskModel> tasks) {
    final group = controller.getGroupController(groupId);
    if (group != null) {
      // Remove all TaskItems and NewTaskInputItems (keep AddButtonItem)
      group.removeWhere((item) => item is TaskItem || item is NewTaskInputItem);

      // Find index of the AddButtonItem
      final addButtonIndex = group.items.indexWhere(
        (item) => item is AddButtonItem,
      );

      final insertIndex = addButtonIndex != -1
          ? addButtonIndex
          : group.items.length;

      // Insert tasks before AddButtonItem
      for (var i = 0; i < tasks.length; i++) {
        group.insert(insertIndex + i, TaskItem(tasks[i]));
      }

      // Ensure the AddButtonItem is at the end
      group.removeWhere((item) => item is AddButtonItem);
      group.add(AddButtonItem());
    }
  }

  void _handleTaskMove(
    String fromGroupId,
    int fromIndex,
    String toGroupId,
    int toIndex,
  ) {
    final fromGroup = controller.getGroupController(fromGroupId);
    if (fromGroup != null) {
      // Get the actual item being moved using the raw index
      if (fromIndex < fromGroup.items.length) {
        final movedItem = fromGroup.items[fromIndex];

        // Only process if it's a TaskItem
        if (movedItem is TaskItem) {
          debugPrint(
            'Moving task ${movedItem.task.id} from $fromGroupId to $toGroupId',
          );

          final taskActions = ref.read(taskActionsProvider);
          taskActions.updateTaskStatus(movedItem.task.id, toGroupId).catchError(
            (error) {
              debugPrint('Error updating task status: $error');
            },
          );
        } else {
          // If it's not a TaskItem (AddButton or InputItem), don't allow the move
          debugPrint('Cannot move non-task item: ${movedItem.runtimeType}');
        }
      }
    }
  }

  void addNewTaskToGroup(String groupId, TaskModel task) {
    final group = controller.getGroupController(groupId);
    if (group != null) {
      final addButtonIndex = group.items.indexWhere(
        (item) => item is AddButtonItem,
      );
      final insertIndex = addButtonIndex != -1
          ? addButtonIndex
          : group.items.length;
      group.insert(insertIndex, TaskItem(task));
    }
  }

  void showAddTaskForm(String groupId) {
    final group = controller.getGroupController(groupId);
    if (group != null) {
      final addButtonIndex = group.items.indexWhere(
        (item) => item is AddButtonItem,
      );
      if (addButtonIndex != -1) {
        group.insert(addButtonIndex, NewTaskInputItem(groupId));
      }
    }
  }

  void cancelAddTask(String groupId) {
    final group = controller.getGroupController(groupId);
    if (group != null) {
      group.removeWhere((item) => item is NewTaskInputItem);
    }
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

  //delete task
  Future<void> deleteTask(String taskId) async {
    try {
      final taskActions = ref.read(taskActionsProvider);
      await taskActions.deleteTask(taskId);
    } catch (error) {
      debugPrint('Error deleting task: $error');
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

  // TaskItems are draggable
  bool get canDrag => true;
}

class AddButtonItem extends AppFlowyGroupItem {
  @override
  String get id => '__add_button__';

  // AddButton is not draggable
  bool get canDrag => false;
}

class NewTaskInputItem extends AppFlowyGroupItem {
  final String groupId;

  NewTaskInputItem(this.groupId);

  @override
  String get id => '__new_task_input_${groupId}__';

  // InputForm is not draggable
  bool get canDrag => false;
}
