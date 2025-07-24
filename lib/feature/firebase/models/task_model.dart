class TaskModel {
  final String id;
  final String title;
  final String status;
  final DateTime? startDate;
  final DateTime? dueDate;
  final String? priority;
  final String? desc;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.status,
    this.startDate,
    this.dueDate,
    this.priority,
    this.desc,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'startDate': startDate?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
      'desc': desc,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      status: map['status'] ?? '',
      startDate: map['startDate'] != null 
          ? DateTime.parse(map['startDate']) 
          : null,
      dueDate: map['dueDate'] != null 
          ? DateTime.parse(map['dueDate']) 
          : null,
      priority: map['priority'],
      desc: map['desc'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? status,
    DateTime? startDate,
    DateTime? dueDate,
    String? priority,
    String? desc,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      desc: desc ?? this.desc,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, status: $status, startDate: $startDate, dueDate: $dueDate, priority: $priority, desc: $desc, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}