enum TaskStatusEnum {
  todo('To Do'),
  inProgress('In Progress'),
  completed('Completed');

  const TaskStatusEnum(this.value);
  final String value;

  static TaskStatusEnum fromString(String value) {
    return TaskStatusEnum.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TaskStatusEnum.todo,
    );
  }
}
