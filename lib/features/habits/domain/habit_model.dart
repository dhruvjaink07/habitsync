class Habit {
  final String id;
  final String title;
  final String notes;
  final String owner;
  final List<String> sharedWith;
  final String repeatPattern;
  final String color;
  final DateTime createdAt;
  final List<String> reminders;

  Habit({
    this.id = '',
    required this.title,
    this.notes = '',
    required this.owner,
    this.sharedWith = const [],
    this.repeatPattern = 'daily',
    this.color = '#2196f3',
    DateTime? createdAt,
    this.reminders = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      notes: json['notes'] ?? '',
      owner: json['owner'] ?? '',
      sharedWith: (json['sharedWith'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      repeatPattern: json['repeatPattern'] ?? 'daily',
      color: json['color'] ?? '#2196f3',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      reminders: (json['reminders'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'notes': notes,
      'owner': owner,
      'sharedWith': sharedWith,
      'repeatPattern': repeatPattern,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
      'reminders': reminders,
    };
  }

  Habit copyWith({
    String? id,
    String? title,
    String? notes,
    String? owner,
    List<String>? sharedWith,
    String? repeatPattern,
    String? color,
    DateTime? createdAt,
    List<String>? reminders,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      owner: owner ?? this.owner,
      sharedWith: sharedWith ?? this.sharedWith,
      repeatPattern: repeatPattern ?? this.repeatPattern,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      reminders: reminders ?? this.reminders,
    );
  }
}
