import 'dart:convert';

class ToDo {
  final int? id;
  final String title;
  final String description;
  final int isCompleted;
  ToDo({
    this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  ToDo copyWith({
    int? id,
    String? title,
    String? description,
    int? isCompleted,
  }) {
    return ToDo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
    };
  }

  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['is_completed'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'ToDo(id: $id, title: $title, description: $description, is_completed: $isCompleted)';
  }
}
