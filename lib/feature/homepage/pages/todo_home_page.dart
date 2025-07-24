// lib/feature/task/widgets/todo_widgets.dart
import 'package:appflowy_board/appflowy_board.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:to_do_web_app/core/constants/app_color.dart';
import 'package:to_do_web_app/core/constants/app_constants.dart';
import 'package:to_do_web_app/core/widgets/app_spacer_widgets.dart';
import 'package:to_do_web_app/core/widgets/button_widget.dart';
import 'package:to_do_web_app/core/widgets/pop_up_menu_widget.dart';
import 'package:to_do_web_app/feature/homepage/controllers/board_controllers.dart';
import 'package:to_do_web_app/feature/homepage/providers/task_provider.dart';

import 'package:to_do_web_app/feature/firebase/models/task_model.dart';

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

  @override
  Widget build(BuildContext context) {
    // Listen to task streams and update the board
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
      appBar: AppBar(title: const Text('To Do Board')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: AppFlowyBoard(
          controller: boardController.controller,
          groupConstraints: const BoxConstraints(minWidth: 300, maxWidth: 300),
          config: AppFlowyBoardConfig(
            groupBackgroundColor: AppColor.secondarySwatch.shade50,
          ),
          headerBuilder: (context, group) => _buildHeader(group),
          cardBuilder: (context, group, groupItem) {
            if (groupItem is AddButtonItem) {
              return _buildAddTaskButtonCard(context, group);
            } else if (groupItem is NewTaskInputItem) {
              return _buildNewTaskInputCard(context, group, groupItem);
            } else if (groupItem is TaskItem) {
              return _buildTaskCard(groupItem.task);
            }
            return const SizedBox.shrink();
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
        borderRadius: BorderRadius.circular(10.spMin),
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
          // Show task count
          Consumer(
            builder: (context, ref, child) {
              final tasksAsync = group.id == 'To Do'
                  ? ref.watch(todoTasksProvider)
                  : group.id == 'In Progress'
                  ? ref.watch(inProgressTasksProvider)
                  : ref.watch(completedTasksProvider);

              return tasksAsync.when(
                data: (tasks) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${tasks.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddTaskButtonCard(
    BuildContext context,
    AppFlowyGroupData group,
  ) {
    return AppFlowyGroupCard(
      key: ValueKey('add_button_${group.id}'),
      margin: EdgeInsets.zero,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.spMin, vertical: 10.spMin),
        child: ButtonWidget.icon(
          height: 40.spMin,
          width: double.infinity,
          backgroundColor: Colors.transparent,
          borderColor: AppColor.primarySwatch.shade300,
          onPressed: () {
            boardController.showAddTaskForm(group.id);
          },
          label: 'Add Task',
          labelColor: AppColor.primarySwatch.shade300,
          icon: Icons.add,
          iconColor: AppColor.primarySwatch.shade300,
          context: context,
        ),
      ),
    );
  }

  Widget _buildNewTaskInputCard(
    BuildContext context,
    AppFlowyGroupData group,
    NewTaskInputItem groupItem,
  ) {
    return _TaskInputForm(
      key: ValueKey('input_form_${groupItem.id}'),
      groupId: group.id,
      boardController: boardController,
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    return AppFlowyGroupCard(
      key: ValueKey('task_${task.id}'),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Task title with delete button
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
                  IconButton(
                    onPressed: () => _showDeleteConfirmation(task),
                    icon: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppColor.errorSwatch.shade700,
                    ),
                  ),
                ],
              ),

              //desc
              if (task.desc != null) ...[
                const SizedBox(height: 8),
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

              // Priority indicator
              if (task.priority != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.flag,
                      size: 16,
                      color: _getPriorityColor(task.priority!),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.priority!,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getPriorityColor(task.priority!),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],

              // Dates
              if (task.startDate != null || task.dueDate != null) ...[
                const SizedBox(height: 8),
                if (task.startDate != null)
                  _buildDateRow('Start:', task.startDate!),
                if (task.dueDate != null) _buildDateRow('Due:', task.dueDate!),
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
          const SizedBox(width: 4),
          Text(
            DateFormat('MMM dd, yyyy').format(date),
            style: TextStyle(
              fontSize: 12,
              color: isOverdue
                  ? AppColor.errorSwatch.shade700
                  : Colors.grey.shade800,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColor.errorSwatch.shade700;
      case 'medium':
        return AppColor.pendingSwatch.shade700;
      case 'low':
        return AppColor.successSwatch.shade700;
      default:
        return Colors.grey;
    }
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

class _TaskInputForm extends StatefulWidget {
  final String groupId;
  final BoardController boardController;

  const _TaskInputForm({
    super.key,
    required this.groupId,
    required this.boardController,
  });

  @override
  State<_TaskInputForm> createState() => _TaskInputFormState();
}

class _TaskInputFormState extends State<_TaskInputForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _dueDate;
  String? _priority;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFlowyGroupCard(
      key: ValueKey('task_input_${widget.groupId}'),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColor.primarySwatch.shade300, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title input with cancel button
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _titleController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        hintText: 'Task name....',
                      ),
                      style: const TextStyle(fontSize: 16),
                      onFieldSubmitted: (_) => _saveTask(),
                    ),
                  ),

                  IconButton(
                    onPressed: () =>
                        widget.boardController.cancelAddTask(widget.groupId),
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: AppColor.errorSwatch.shade700,
                    ),
                  ),
                ],
              ),

              AppSpacerWidget(),
              TextFormField(
                controller: _descriptionController,
                autofocus: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  hintText: 'Description....',
                ),
                style: const TextStyle(fontSize: 16),
                onFieldSubmitted: (_) => _saveTask(),
              ),
              AppSpacerWidget(),
              // Options row
              Row(
                children: [
                  // Date picker
                  Expanded(
                    child: PopUpMenuWidget(
                      tooltip: 'Add Dates',
                      items: [
                        PopupMenuItem(
                          child: _buildDatePickerField(
                            'Start Date',
                            _startDate,
                            (date) {
                              setState(() => _startDate = date);
                            },
                          ),
                        ),
                        PopupMenuItem(
                          child: _buildDatePickerField('Due Date', _dueDate, (
                            date,
                          ) {
                            setState(() => _dueDate = date);
                          }),
                        ),
                      ],
                      icon: Icons.calendar_today,
                      text: 'Dates',
                    ),
                  ),

                  AppSpacerWidget(),

                  // Priority picker
                  Expanded(
                    child: PopUpMenuWidget(
                      tooltip: 'Set Priority',
                      onSelected: (value) {
                        setState(() => _priority = value.toString());
                      },
                      items: [
                        PopupMenuItem(
                          value: 'High',
                          child: Row(
                            children: [
                              Icon(
                                Icons.flag,
                                color: AppColor.errorSwatch.shade700,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              const Text('High'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'Medium',
                          child: Row(
                            children: [
                              Icon(
                                Icons.flag,
                                color: AppColor.pendingSwatch.shade700,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              const Text('Medium'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'Low',
                          child: Row(
                            children: [
                              Icon(
                                Icons.flag,
                                color: AppColor.successSwatch.shade700,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              const Text('Low'),
                            ],
                          ),
                        ),
                      ],
                      icon: Icons.flag,
                      text: _priority ?? 'Priority',
                    ),
                  ),
                ],
              ),

              AppSpacerWidget(),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ButtonWidget(
                  onPressed: _isLoading ? null : _saveTask,
                  label: _isLoading ? 'Saving...' : 'Save Task',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(
    String label,
    DateTime? currentDate,
    Function(DateTime?) onChanged,
  ) {
    return SizedBox(
      width: 200,
      child: DateTimeFormField(
        pickerPlatform: DateTimeFieldPickerPlatform.material,
        dateFormat: DateFormat("MMM dd, yyyy"),
        initialValue: currentDate,
        mode: DateTimeFieldPickerMode.date,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _saveTask() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await widget.boardController.saveNewTask(
        groupId: widget.groupId,
        title: title,
        startDate: _startDate,
        desc: _descriptionController.text.trim(),
        dueDate: _dueDate,
        priority: _priority,
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating task: $error'),
            backgroundColor: AppColor.errorSwatch.shade700,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
