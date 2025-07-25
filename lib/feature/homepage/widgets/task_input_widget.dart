import 'package:appflowy_board/appflowy_board.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_web_app/core/constants/app_color.dart';
import 'package:to_do_web_app/core/widgets/app_spacer_widgets.dart';
import 'package:to_do_web_app/core/widgets/button_widget.dart';
import 'package:to_do_web_app/core/widgets/pop_up_menu_widget.dart';
import 'package:to_do_web_app/feature/homepage/controllers/board_controllers.dart';
import 'package:to_do_web_app/feature/firebase/models/task_model.dart';

class TaskInputWidget extends StatefulWidget {
  final String groupId;
  final BoardController boardController;
  final TaskModel? taskToEdit;
  final bool isEditMode;

  const TaskInputWidget({
    super.key,
    required this.groupId,
    required this.boardController,
    this.taskToEdit,
    this.isEditMode = false,
  });

  @override
  State<TaskInputWidget> createState() => _TaskInputWidgetState();
}

class _TaskInputWidgetState extends State<TaskInputWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _dueDate;
  String? _priority;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (widget.isEditMode && widget.taskToEdit != null) {
      final task = widget.taskToEdit!;
      _titleController.text = task.title;
      _descriptionController.text = task.desc ?? '';
      _startDate = task.startDate;
      _dueDate = task.dueDate;
      _priority = task.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppFlowyGroupCard(
      key: ValueKey(
        'task_input_${widget.groupId}_${widget.isEditMode ? widget.taskToEdit?.id : 'new'}',
      ),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColor.onDarkSwatch : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColor.primarySwatch.shade300, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title input with cancel button
                Row(
                  children: [
                    Expanded(
                      child: buildTextField(
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Task title cannot be empty';
                          }
                          return null;
                        },
                        controller: _titleController,
                        hintText: 'Task name....',
                        autofocus: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        onFieldSubmitted: (_) => _saveTask(),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                      ),
                    ),
                    IconButton(
                      onPressed: _cancelAction,
                      icon: Icon(
                        Icons.close,
                        size: 15,
                        color: AppColor.errorSwatch.shade700,
                      ),
                    ),
                  ],
                ),
                buildTextField(
                  controller: _descriptionController,
                  hintText: 'Description....',
                  autofocus: false,
                  onFieldSubmitted: (_) => _saveTask(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  ),
                ),
                AppSpacerWidget(),
                // Options row
                PopUpMenuWidget(
                  tooltip: 'Add Dates',
                  items: [
                    PopupMenuItem(
                      child: _buildDatePickerField('Start Date', _startDate, (
                        date,
                      ) {
                        setState(() => _startDate = date);
                      }),
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      child: _buildDatePickerField('Due Date', _dueDate, (
                        date,
                      ) {
                        setState(() => _dueDate = date);
                      }),
                    ),
                  ],
                  icon: Icons.calendar_today,
                  text: _getDateText(),
                ),
                AppSpacerWidget(),
                PopUpMenuWidget(
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
                          Text(
                            'High',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
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
                          Text(
                            'Medium',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
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
                          Text(
                            'Low',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                  icon: Icons.flag,
                  text: _priority ?? 'Priority',
                ),

                AppSpacerWidget(),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ButtonWidget(
                    onPressed: _isLoading ? null : _saveTask,
                    label: _isLoading
                        ? (widget.isEditMode ? 'Updating...' : 'Saving...')
                        : (widget.isEditMode ? 'Update Task' : 'Save Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDateText() {
    if (_startDate != null && _dueDate != null) {
      return '${DateFormat('yyyy MMM dd ').format(_startDate!)} - ${DateFormat('yyyy MMM dd').format(_dueDate!)}';
    } else if (_startDate != null) {
      return 'Start: ${DateFormat('MMM dd').format(_startDate!)}';
    } else if (_dueDate != null) {
      return 'Due: ${DateFormat('MMM dd').format(_dueDate!)}';
    }
    return 'Dates';
  }

  void _cancelAction() {
    if (widget.isEditMode) {
      widget.boardController.cancelEditTask(widget.taskToEdit!.id);
    } else {
      widget.boardController.cancelAddTask(widget.groupId);
    }
  }

  Widget buildTextField({
    required TextEditingController controller,
    String? label,
    String? hintText,
    String? Function(String?)? validator,
    bool readOnly = false,
    bool autofocus = false,
    TextStyle? style,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    InputBorder? border,
    InputBorder? enabledBorder,
    InputBorder? focusedBorder,
    void Function(String)? onFieldSubmitted,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      autofocus: autofocus,
      style:
          style ??
          Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDark ? Colors.white : Colors.black,
          ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: label != null
            ? Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              )
            : null,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
        ),
        contentPadding: contentPadding,
        border:
            border ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: isDark ? Colors.grey.shade600 : Colors.grey,
              ),
            ),
        enabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: isDark ? Colors.grey.shade600 : Colors.grey,
              ),
            ),
        focusedBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.primarySwatch.shade300),
            ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        fillColor: isDark ? AppColor.onDarkSwatch : Colors.white,
        filled: true,
      ),
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  Widget _buildDatePickerField(
    String label,
    DateTime? currentDate,
    Function(DateTime?) onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 200,
      child: DateTimeFormField(
        pickerPlatform: DateTimeFieldPickerPlatform.material,
        dateFormat: DateFormat("MMM dd, yyyy hh:mm a"),
        initialValue: currentDate,
        mode: DateTimeFieldPickerMode.dateAndTime,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDark ? Colors.grey.shade600 : Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDark ? Colors.grey.shade600 : Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColor.primarySwatch.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          fillColor: isDark ? AppColor.onDarkSwatch : Colors.white,
          filled: true,
        ),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stops saving if validation fails
    }
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      if (widget.isEditMode) {
        await widget.boardController.updateTask(
          taskId: widget.taskToEdit!.id,
          title: title,
          startDate: _startDate,
          desc: _descriptionController.text.trim(),
          dueDate: _dueDate,
          priority: _priority,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Task updated successfully',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
              backgroundColor: AppColor.successSwatch.shade700,
            ),
          );
        }
      } else {
        await widget.boardController.saveNewTask(
          groupId: widget.groupId,
          title: title,
          startDate: _startDate,
          desc: _descriptionController.text.trim(),
          dueDate: _dueDate,
          priority: _priority,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Task saved successfully',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
              backgroundColor: AppColor.successSwatch.shade700,
            ),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error ${widget.isEditMode ? 'updating' : 'creating'} task: $error',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
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
