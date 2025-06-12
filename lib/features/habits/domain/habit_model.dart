import 'package:habitsync/features/auth/domain/user_model.dart';

class Habit {
  final String? id;
  final String title;
  final String notes;
  final User owner;
  final List<User> sharedWith;
  final String repeatPattern;
  final String color;
  final DateTime createdAt;
  final List<String> reminders;

  // Main constructor (for fetched habits)
  Habit({
    this.id,
    required this.title,
    required this.notes,
    required this.owner,
    required this.sharedWith,
    this.repeatPattern = 'daily',
    this.color = '#2196f3',
    DateTime? createdAt,
    this.reminders = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  // Named constructor for creation (using IDs)
  Habit.create({
    this.id,
    required this.title,
    required this.notes,
    required String ownerId,
    required List<String> sharedWithIds,
    this.repeatPattern = 'daily',
    this.color = '#2196f3',
    DateTime? createdAt,
    this.reminders = const [],
  })  : owner = User(
          id: ownerId,
          name: '',
          email: '',
          avatar: '',
          username: '',
          bio: '',
          streak: 0,
          friends: const [],
          joinedAt: DateTime.now().toIso8601String(),
        ),
        sharedWith = sharedWithIds
            .map((id) => User(
                  id: id,
                  name: '',
                  email: '',
                  avatar: '',
                  username: '',
                  bio: '',
                  streak: 0,
                  friends: const [],
                  joinedAt: DateTime.now().toIso8601String(),
                ))
            .toList(),
        createdAt = createdAt ?? DateTime.now();

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['_id'],
        title: json['title'],
        notes: json['notes'],
        owner: User.fromJson(json['owner']),
        sharedWith:
            (json['sharedWith'] as List).map((u) => User.fromJson(u)).toList(),
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

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      'notes': notes,
      'owner': owner.id, // Only send the ID for creation
      'sharedWith': sharedWith.map((u) => u.id).toList(),
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
    User? owner,
    List<User>? sharedWith,
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
