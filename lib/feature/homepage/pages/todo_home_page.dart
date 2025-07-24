import 'package:appflowy_board/appflowy_board.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:to_do_web_app/core/constants/app_color.dart';
import 'package:to_do_web_app/core/constants/app_constants.dart';
import 'package:to_do_web_app/core/widgets/app_spacer_widgets.dart';
import 'package:to_do_web_app/core/widgets/button_widget.dart';
import 'package:to_do_web_app/core/widgets/pop_up_menu_widget.dart';

class TodoWidgets extends StatefulWidget {
  const TodoWidgets({super.key});

  @override
  State<TodoWidgets> createState() => _TodoWidgetsState();
}

class _TodoWidgetsState extends State<TodoWidgets> {
  late final AppFlowyBoardController controller;

  @override
  void initState() {
    super.initState();

    controller = AppFlowyBoardController(
      onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
        debugPrint('Move group from $fromIndex to $toIndex');
      },
      onMoveGroupItem: (groupId, fromIndex, toIndex) {
        debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
      },
      onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
        debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
      },
    );

    controller.addGroup(
      AppFlowyGroupData(
        id: "To Do",
        name: "To Do",
        items: [TextItem("Task 1"), TextItem("Task 2"), AddButtonItem()],
      ),
    );

    controller.addGroup(
      AppFlowyGroupData(
        id: "In Progress",
        name: "In Progress",
        items: [TextItem("Task 3"), TextItem("Task 4"), AddButtonItem()],
      ),
    );

    controller.addGroup(
      AppFlowyGroupData(
        id: "Completed",
        name: "Completed",
        items: [TextItem("Task 5"), TextItem("Task 6"), AddButtonItem()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To Do Page')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: AppFlowyBoard(
          controller: controller,
          groupConstraints: const BoxConstraints(minWidth: 300, maxWidth: 300),
          config: AppFlowyBoardConfig(
            groupBackgroundColor: AppColor.secondarySwatch.shade50,
          ),
          headerBuilder: (context, group) => _iconContainer(
            AppConstants.getBoardIcon(group.id),
            onPressed: () {},
            backgroundColor: AppConstants.getBoardColor(group.id),
            label: group.id,
          ),
          cardBuilder: (context, group, groupItem) {
            if (groupItem is AddButtonItem) {
              return _buildAddTaskButtonCard(context, group, groupItem);
            } else if (groupItem is NewTaskInputItem) {
              return _buildNewTaskInputCard(context, group, groupItem);
            } else if (groupItem is TextItem) {
              return _buildTextItemCard(groupItem);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildAddTaskButtonCard(
    BuildContext context,
    AppFlowyGroupData group,
    AddButtonItem groupItem,
  ) {
    return AppFlowyGroupCard(
      margin: EdgeInsets.zero,
      decoration: const BoxDecoration(color: Colors.transparent),
      key: ObjectKey(groupItem),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.spMin, vertical: 10.spMin),
        child: ButtonWidget.icon(
          height: 30.spMin,
          width: 150.spMin,
          backgroundColor: Colors.transparent,
          borderColor: AppColor.primarySwatch.shade300,
          onPressed: () {
            final index = group.items.indexOf(groupItem);
            controller.insertGroupItem(group.id, index, NewTaskInputItem());
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
    final taskController = TextEditingController();

    return AppFlowyGroupCard(
      decoration: const BoxDecoration(color: Colors.transparent),
      key: ObjectKey(groupItem),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColor.primarySwatch.shade300, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: taskController,
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
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        controller.removeGroupItem(group.id, groupItem.id),
                    icon: Icon(
                      Icons.cancel_rounded,
                      size: 20,
                      color: AppColor.errorSwatch.shade900,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PopUpMenuWidget(
                    tooltip: 'Add Deadline',

                    items: [
                      PopupMenuItem(child: _buildDatePickerField('Start Date')),
                      PopupMenuItem(child: _buildDatePickerField('End Date')),
                      PopupMenuItem(
                        child: ButtonWidget(label: 'Save', onPressed: () {}),
                      ),
                    ],
                    icon: Icons.calendar_month,
                    text: 'Add Deadline',
                  ),

                  PopUpMenuWidget(
                    tooltip: 'Add Priority',
                    onSelected: (value) {
                      // handle priority selection
                    },
                    items: [
                      PopupMenuItem(
                        value: 'High',
                        child: Row(
                          children: [
                            Icon(
                              Icons.flag,
                              color: AppColor.errorSwatch.shade900,
                            ),
                            SizedBox(width: 8),
                            Text('High'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Medium',
                        child: Row(
                          children: [
                            Icon(
                              Icons.flag,
                              color: AppColor.pendingSwatch.shade900,
                            ),
                            SizedBox(width: 8),
                            Text('Medium'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Low',
                        child: Row(
                          children: [
                            Icon(
                              Icons.flag,
                              color: AppColor.successSwatch.shade900,
                            ),
                            SizedBox(width: 8),
                            Text('Low'),
                          ],
                        ),
                      ),
                    ],
                    icon: Icons.flag,
                    text: 'Add Priority',
                  ),
                ],
              ),
              const AppSpacerWidget(),
              ButtonWidget(
                onPressed: () {
                  final text = taskController.text.trim();
                  if (text.isNotEmpty) {
                    final index = group.items.indexOf(groupItem);
                    controller.insertGroupItem(
                      group.id,
                      index,
                      TextItem(
                        text,
                        startDate: DateTime.now(),
                        dueDate: DateTime.now(),
                      ),
                    );
                    controller.removeGroupItem(group.id, groupItem.id);
                  }
                },
                label: 'Save',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextItemCard(TextItem textItem) {
    return AppFlowyGroupCard(
      decoration: const BoxDecoration(color: Colors.transparent),
      key: ObjectKey(textItem),
      child: Container(
        width: 300,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(textItem.text, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label) {
    return SizedBox(
      child: DateTimeFormField(
        pickerPlatform: DateTimeFieldPickerPlatform.material,
        dateFormat: DateFormat("yyyy-MM-dd"),
        initialValue: DateTime.now(),
        mode: DateTimeFieldPickerMode.date,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.spMin),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        onChanged: (value) {},
      ),
    );
  }
}

Widget _iconContainer(
  Icon icon, {
  required VoidCallback onPressed,
  String? label,
  Color? backgroundColor,
}) {
  return Container(
    padding: EdgeInsets.all(10.spMin),
    decoration: BoxDecoration(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(10.spMin),
    ),
    child: Row(
      children: [
        Icon(icon.icon, color: Colors.black, size: 20.spMin),
        AppSpacerWidget(width: 10.spMin),
        Text(label ?? ''),
      ],
    ),
  );
}

class TextItem extends AppFlowyGroupItem {
  final String text;
  final DateTime? startDate;
  final DateTime? dueDate;

  TextItem(this.text, {this.startDate, this.dueDate});

  @override
  String get id => text;
}

class AddButtonItem extends AppFlowyGroupItem {
  @override
  String get id => '__add_button__';
}

class NewTaskInputItem extends AppFlowyGroupItem {
  @override
  String get id => '__new_task_input__';
}
