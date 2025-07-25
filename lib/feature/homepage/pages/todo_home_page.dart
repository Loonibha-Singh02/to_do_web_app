import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:to_do_web_app/core/constants/app_color.dart';
import 'package:to_do_web_app/core/constants/app_constants.dart';
import 'package:to_do_web_app/core/widgets/app_spacer_widgets.dart';
import 'package:to_do_web_app/core/widgets/button_widget.dart';
import 'package:to_do_web_app/feature/homepage/controllers/board_controllers.dart';
import 'package:to_do_web_app/feature/homepage/providers/task_provider.dart';
import 'package:to_do_web_app/feature/firebase/models/task_model.dart';
import 'package:to_do_web_app/feature/homepage/widgets/priority_filter_widget.dart';
import 'package:to_do_web_app/feature/homepage/widgets/status_filter_widget.dart';
import 'package:to_do_web_app/feature/homepage/widgets/task_input_widget.dart';

class TodoWidgets extends ConsumerStatefulWidget {
  const TodoWidgets({super.key});

  @override
  ConsumerState<TodoWidgets> createState() => _TodoWidgetsState();
}

class _TodoWidgetsState extends ConsumerState<TodoWidgets> {
  late final BoardController boardController;

  @override
  void initState() {
    super.initState();
    boardController = BoardController(ref);
    boardController.initializeBoard();
  }

  @override
  void dispose() {
    boardController.dispose();
    super.dispose();
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      key: UniqueKey(),
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        width: 280,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedPriorities = ref.watch(selectedPrioritiesProvider);

    ref.listen(todoTasksProvider, (previous, next) {
      next.whenData((tasks) {
        boardController.updateGroupWithTasks('To Do', tasks);
      });
    });

    ref.listen(inProgressTasksProvider, (previous, next) {
      next.whenData((tasks) {
        boardController.updateGroupWithTasks('In Progress', tasks);
      });
    });

    ref.listen(completedTasksProvider, (previous, next) {
      next.whenData((tasks) {
        boardController.updateGroupWithTasks('Completed', tasks);
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do Board'),
        actions: [
          Row(
            children: [
              PriorityFilterWidget(),
              const AppSpacerWidget(width: 12),
              StatusFilterWidget(),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: AppFlowyBoard(
          controller: boardController.controller,
          groupConstraints: const BoxConstraints(minWidth: 300, maxWidth: 300),
          config: AppFlowyBoardConfig(
            groupBackgroundColor: AppColor.secondarySwatch.shade50,
          ),
          headerBuilder: (context, group) => _buildHeader(group),
          footerBuilder: (context, group) => _buildFooter(context, group),
          cardBuilder: (context, group, groupItem) {
            final tasksAsync = group.id == 'To Do'
                ? ref.watch(todoTasksProvider)
                : group.id == 'In Progress'
                ? ref.watch(inProgressTasksProvider)
                : ref.watch(completedTasksProvider);

            return tasksAsync.when(
              loading: () => _buildShimmerCard(),
              error: (_, __) => SizedBox.shrink(
                key: ValueKey(
                  'error_${group.id}_${DateTime.now().millisecondsSinceEpoch}',
                ),
              ),
              data: (tasks) {
                // Show "No Data" card if no tasks and filters are active
                if (tasks.isEmpty && selectedPriorities.isNotEmpty) {
                  return _buildNoDataCard(group.id);
                }

                if (groupItem is TaskItem) {
                  // Check if this task is being edited
                  if (boardController.isTaskBeingEdited(groupItem.task.id)) {
                    return TaskInputWidget(
                      key: ValueKey('edit_${groupItem.task.id}'),
                      groupId: group.id,
                      boardController: boardController,
                      taskToEdit: groupItem.task,
                      isEditMode: true,
                    );
                  }
                  return _buildTaskCard(groupItem.task);
                }
                return SizedBox.shrink(
                  key: ValueKey(
                    'empty_${group.id}_${DateTime.now().millisecondsSinceEpoch}',
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(AppFlowyGroupData group) {
    return Container(
      padding: EdgeInsets.all(10.spMin),
      decoration: BoxDecoration(
        color: AppConstants.getBoardColor(group.id),
        borderRadius: BorderRadius.circular(5.spMin),
      ),
      child: Row(
        children: [
          AppConstants.getBoardIcon(group.id),
          AppSpacerWidget(width: 10.spMin),
          Text(
            group.id,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          // Count
          Consumer(
            builder: (context, ref, child) {
              final tasksAsync = group.id == 'To Do'
                  ? ref.watch(todoTasksProvider)
                  : group.id == 'In Progress'
                  ? ref.watch(inProgressTasksProvider)
                  : ref.watch(completedTasksProvider);

              return tasksAsync.when(
                data: (tasks) => CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 12.spMin,
                  child: Text(
                    '${tasks.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                loading: () => Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    radius: 12.spMin,
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, AppFlowyGroupData group) {
    return Column(
      key: ValueKey('footer_${group.id}'),
      mainAxisSize: MainAxisSize.min,
      children: [
        if (boardController.hasInputForm(group.id))
          Padding(
            key: ValueKey('input_padding_${group.id}'),
            padding: EdgeInsets.only(bottom: 8.spMin),
            child: TaskInputWidget(
              key: ValueKey('input_form_${group.id}'),
              groupId: group.id,
              boardController: boardController,
            ),
          ),
        _buildAddTaskButtonCard(context, group),
      ],
    );
  }

  Widget _buildAddTaskButtonCard(
    BuildContext context,
    AppFlowyGroupData group,
  ) {
    return Padding(
      key: ValueKey('add_button_padding_${group.id}'),
      padding: EdgeInsets.symmetric(horizontal: 5.spMin, vertical: 10.spMin),
      child: ButtonWidget.icon(
        height: 40.spMin,
        width: double.infinity,
        backgroundColor: Colors.transparent,
        borderColor: AppColor.primarySwatch.shade300,
        onPressed: () {
          setState(() {
            boardController.showAddTaskForm(group.id);
          });
        },
        label: 'Add Task',
        labelColor: AppColor.primarySwatch.shade300,
        icon: Icons.add,
        iconColor: AppColor.primarySwatch.shade300,
        context: context,
      ),
    );
  }

  Widget _buildNoDataCard(String groupId) {
    return AppFlowyGroupCard(
      key: ValueKey('no_data_$groupId'),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.filter_list_off, size: 40, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'No tasks match the current filter',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filter settings',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    final isOverdue =
        task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        task.status != 'Completed';
    return AppFlowyGroupCard(
      key: ValueKey('task_${task.id}'),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isOverdue
                ? AppColor.errorSwatch.shade700
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            boardController.startEditingTask(task);
                          });
                        },
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: AppColor.primarySwatch.shade700,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showDeleteConfirmation(task),
                        icon: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: AppColor.errorSwatch.shade900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (task.desc != null) ...[
                const AppSpacerWidget(),
                Text(
                  task.desc!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (task.priority != null) ...[
                const AppSpacerWidget(),
                Row(
                  children: [
                    Icon(
                      Icons.flag,
                      size: 16,
                      color: AppConstants.getPriorityColor(task.priority!),
                    ),
                    const AppSpacerWidget(width: 4),
                    Text(
                      task.priority!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppConstants.getPriorityColor(task.priority!),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              if (task.startDate != null || task.dueDate != null) ...[
                const AppSpacerWidget(),
                Row(
                  children: [
                    if (task.startDate != null)
                      Expanded(child: _buildDateRow('Start:', task.startDate!)),
                    if (task.dueDate != null)
                      Expanded(child: _buildDateRow('Due:', task.dueDate!)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateRow(String label, DateTime date) {
    final isOverdue = date.isBefore(DateTime.now()) && label == 'Due:';

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            DateFormat('MMM dd, yyyy').format(date),
            style: TextStyle(
              fontSize: 12,
              color: isOverdue
                  ? AppColor.errorSwatch.shade900
                  : Colors.grey.shade800,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(TaskModel task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              boardController.deleteTask(task.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColor.errorSwatch.shade700,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
