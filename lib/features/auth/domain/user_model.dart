class User {
  final String id;
  final String username;
  final String name;
  final String email;
  final String avatar;
  final String bio;
  final int streak;
  final int sharedStreak;
  final List<String> friends;
  final List<String> friendRequests;
  final String joinedAt;

  User(
      {required this.id,
      required this.username,
      required this.name,
      required this.email,
      required this.avatar,
      required this.bio,
      required this.streak,
      required this.sharedStreak,
      required this.friends,
      required this.joinedAt,
      this.friendRequests = const []});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      bio: json['bio'] ?? '',
      streak: json['streak'] ?? 0,
      sharedStreak: json['sharedStreak'] ?? 0,
      friends: (json['friends'] as List<dynamic>?)?.cast<String>() ?? [],
      friendRequests:
          (json['friendRequests'] as List<dynamic>?)?.cast<String>() ?? [],
      joinedAt: json['joinedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'name': name,
      'email': email,
      'avatar': avatar,
      'bio': bio,
      'streak': streak,
      'sharedStreak': sharedStreak,
      'friends': friends,
      'joinedAt': joinedAt,
      'friendRequests': friendRequests,
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? name,
    String? email,
    String? avatar,
    String? bio,
    int? streak,
    int? sharedStreak,
    List<String>? friends,
    String? joinedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      streak: streak ?? this.streak,
      sharedStreak: sharedStreak ?? this.sharedStreak,
      friends: friends ?? this.friends,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
