enum TaskPriorityEnum {
  high('High'),
  medium('Medium'),
  low('Low');

  const TaskPriorityEnum(this.value);
  final String value;

  static TaskPriorityEnum? fromString(String? value) {
    if (value == null) return null;
    return TaskPriorityEnum.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => TaskPriorityEnum.medium,
    );
  }
}
