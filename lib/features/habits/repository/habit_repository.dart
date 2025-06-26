import 'package:habitsync/features/habits/data/habit_service.dart';
import 'package:habitsync/features/habits/domain/habit_model.dart';

class HabitRepository {
  final HabitService _habitService = HabitService();

  Future<List<Habit>> getHabits() async {
    try {
      return await _habitService.getHabits();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Habit>> getHabitsByOwnerId(String ownerId) async {
    try {
      return await _habitService.getHabitsByOwner(ownerId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Habit> getHabitById(String habitId) async {
    try {
      return await _habitService.getHabitById(habitId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Habit>> getSharedHabits(String userId) async {
    try {
      return await _habitService.getSharedHabits(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createHabit(Habit habit) async {
    try {
      await _habitService.createHabit(habit);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      await _habitService.updateHabit(habit);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      await _habitService.deleteHabit(habitId);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> markHabitAsDone(String habitId, String date) async {
    try {
      return await _habitService.markHabitComplete(
          habitId: habitId, date: date);
    } catch (e) {
      rethrow;
    }
  }
}
