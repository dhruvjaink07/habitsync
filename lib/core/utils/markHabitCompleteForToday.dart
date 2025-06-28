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

// Removed local streak logic - using backend API only

Future<void> incrementStreakIfNeeded({required String streakType}) async {
  final box = await Hive.openBox('streakIncrements');
  final today = DateTime.now().toIso8601String().substring(0, 10);
  final lastUpdateKey = '${streakType}_lastIncrement';

  final lastUpdate = box.get(lastUpdateKey, defaultValue: '');
  if (lastUpdate != today) {
    print('Incrementing $streakType streak for $today');
    await HabitService().incrementUserStreak();
    await box.put(lastUpdateKey, today);
    print('Streak increment API called successfully');
  } else {
    print('$streakType streak already incremented today ($today)');
  }
}
