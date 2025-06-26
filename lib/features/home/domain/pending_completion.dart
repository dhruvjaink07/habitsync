import 'package:hive/hive.dart';

part 'pending_completion.g.dart';

@HiveType(typeId: 1)
class PendingCompletion extends HiveObject {
  @HiveField(0)
  String habitId;

  @HiveField(1)
  String date;

  @HiveField(2)
  String status;

  PendingCompletion({
    required this.habitId,
    required this.date,
    this.status = "complete",
  });
}
