import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habitsync/features/habits/data/habit_service.dart';

// Add this utility function in a suitable place (e.g., a service or directly in HabitCard)
Future<void> markHabitCompletedForToday(String habitId) async {
  final box = await Hive.openBox('completedHabits');
  final today = DateTime.now().toIso8601String().substring(0, 10);
  final List completed = box.get(today, defaultValue: <String>[]);
  if (!completed.contains(habitId)) {
    completed.add(habitId);
    await box.put(today, completed);
  }
}

Future<bool> isHabitCompletedToday(String habitId) async {
  final box = await Hive.openBox('completedHabits');
  final today = DateTime.now().toIso8601String().substring(0, 10);
  final List completed = box.get(today, defaultValue: <String>[]);
  return completed.contains(habitId);
}

Future<void> updateStreakIfNeeded({
  required String streakType, // 'personal' or 'shared'
  required bool hasCompletedToday,
}) async {
  final box = await Hive.openBox('streaks');
  final today = DateTime.now().toIso8601String().substring(0, 10);
  final lastUpdateKey = '${streakType}_lastUpdate';
  final streakKey = '${streakType}_streak';

  final lastUpdate = box.get(lastUpdateKey, defaultValue: '');
  int streak = box.get(streakKey, defaultValue: 0);

  if (lastUpdate != today && hasCompletedToday) {
    streak += 1;
    await box.put(streakKey, streak);
    await box.put(lastUpdateKey, today);
  }
}

Future<int> getStreak(String streakType) async {
  final box = await Hive.openBox('streaks');
  return box.get('${streakType}_streak', defaultValue: 0);
}

Future<void> incrementStreakIfNeeded({required String streakType}) async {
  final box = await Hive.openBox('streaks');
  final today = DateTime.now().toIso8601String().substring(0, 10);
  final lastUpdateKey = '${streakType}_lastIncrement';

  final lastUpdate = box.get(lastUpdateKey, defaultValue: '');
  if (lastUpdate != today) {
    await HabitService().incrementUserStreak();
    await box.put(lastUpdateKey, today);
  }
}
