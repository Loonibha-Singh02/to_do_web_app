enum SortByEnum {
  deadline('Deadline'),
  priority('Priority'),
  createdDate('Created Date'),
  title('Title');

  const SortByEnum(this.value);
  final String value;
}
