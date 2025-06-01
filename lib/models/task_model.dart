class TaskModel {
  String? id;
  String? title;
  String? description;
  int? streakCount;
  bool isShared = false;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.streakCount,
    this.isShared = false,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    streakCount = json['streakCount'];
    isShared = json['isShared'] ?? false; // Default to false if not provided
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'streakCount': streakCount,
      'isShared': isShared,
    };
  }
}
