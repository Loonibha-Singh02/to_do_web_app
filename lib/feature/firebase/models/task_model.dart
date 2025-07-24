/// Model class for TaskModel data
class TaskModel {
  final String id;
  final String title;
  final String? desc;
  final String status; // 'To Do', 'In Progress', 'Completed'
  final DateTime? startDate;
  final DateTime? dueDate;
  final String? priority; // 'High', 'Medium', 'Low'
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    this.desc,
    required this.status,
    this.startDate,
    this.dueDate,
    this.priority,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert TaskModel object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'desc': desc,
      'startDate': startDate?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create TaskModel object from Firestore document
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      desc: map['desc'] ?? '',
      status: map['status'] ?? 'To Do',
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : null,
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      priority: map['priority'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  /// Create a copy of the task with updated values
  TaskModel copyWith({
    String? id,
    String? title,
    String? status,
    String? desc,
    DateTime? startDate,
    DateTime? dueDate,
    String? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      desc: desc ?? this.desc,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
