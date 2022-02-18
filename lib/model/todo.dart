import 'dart:convert';

class ToDo {
  final int? id;
  final String title;
  final String description;
  final int isCompleted;
  final String date;
  final String time;
  final int categoryId;
  ToDo({
    this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.date,
    required this.time,
    required this.categoryId,
  });

  ToDo copyWith(
      {int? id,
      String? title,
      String? description,
      int? isCompleted,
      String? date,
      String? time,
      int? categoryId}) {
    return ToDo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      time: time ?? this.time,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
      'date': date,
      'time': time,
      'category_id': categoryId,
    };
  }

  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['is_completed'] ?? 0,
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      categoryId: map['category_id'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'ToDo(id: $id, title: $title, description: $description, is_completed: $isCompleted, date: $date, time: $time)';
  }
}
