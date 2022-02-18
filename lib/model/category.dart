import 'dart:convert';

class Category {
  final int? id;
  final String title;
  final int total;
  final int completed;
  final int color;

  Category({
    this.id,
    required this.title,
    required this.total,
    required this.completed,
    required this.color,
  });

  Category copyWith({
    int? id,
    String? title,
    int? total,
    int? completed,
    int? color,
  }) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
      total: total ?? this.total,
      completed: completed ?? this.completed,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'total': total,
      'completed': completed,
      'color': color,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      total: map['total']?.toInt() ?? 0,
      completed: map['completed']?.toInt() ?? 0,
      color: map['color']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Category(id: $id, title: $title, total: $total, completed: $completed, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.id == id &&
        other.title == title &&
        other.total == total &&
        other.completed == completed &&
        other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        total.hashCode ^
        completed.hashCode ^
        color.hashCode;
  }
}
