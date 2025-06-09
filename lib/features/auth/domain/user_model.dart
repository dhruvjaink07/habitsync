class User {
  final String id;
  final String username;
  final String email;
  final String avatar;
  final String bio;
  final List<String> friends;
  final String joinedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.avatar,
    required this.bio,
    required this.friends,
    required this.joinedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      bio: json['bio'] ?? '',
      friends: (json['friends'] as List<dynamic>?)?.cast<String>() ?? [],
      joinedAt: json['joinedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar_url': avatar,
      'bio': bio,
      'friends': friends,
      'created_at': joinedAt,
    };
  }
}
