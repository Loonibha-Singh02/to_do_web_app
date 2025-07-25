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
    return AppFlowyGroupCard(
      key: ValueKey(
        'task_input_${widget.groupId}_${widget.isEditMode ? widget.taskToEdit?.id : 'new'}',
      ),
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
                    child: buildTextField(
                      controller: _titleController,
                      hintText: 'Task name....',
                      autofocus: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      onFieldSubmitted: (_) => _saveTask(),
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
                    child: _buildDatePickerField('Due Date', _dueDate, (date) {
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
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      autofocus: autofocus,
      style: style ?? const TextStyle(fontSize: 16),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: label != null
            ? const TextStyle(fontWeight: FontWeight.bold)
            : null,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: hintText,
        contentPadding: contentPadding,
        border: border ?? const OutlineInputBorder(),
        enabledBorder:
            enabledBorder ??
            const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
        focusedBorder:
            focusedBorder ??
            const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
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
    return SizedBox(
      width: 200,
      child: DateTimeFormField(
        pickerPlatform: DateTimeFieldPickerPlatform.material,
        dateFormat: DateFormat("MMM dd, yyyy hh:mm a"),
        initialValue: currentDate,
        mode: DateTimeFieldPickerMode.dateAndTime,
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
      if (widget.isEditMode) {
        await widget.boardController.updateTask(
          taskId: widget.taskToEdit!.id,
          title: title,
          startDate: _startDate,
          desc: _descriptionController.text.trim(),
          dueDate: _dueDate,
          priority: _priority,
        );
      } else {
        await widget.boardController.saveNewTask(
          groupId: widget.groupId,
          title: title,
          startDate: _startDate,
          desc: _descriptionController.text.trim(),
          dueDate: _dueDate,
          priority: _priority,
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error ${widget.isEditMode ? 'updating' : 'creating'} task: $error',
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
