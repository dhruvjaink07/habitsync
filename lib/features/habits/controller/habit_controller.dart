import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitsync/features/habits/domain/habit_model.dart';
import 'package:habitsync/features/habits/repository/habit_repository.dart';

final habitControllerProvider =
    StateNotifierProvider<HabitController, AsyncValue<List<Habit>>>(
  (ref) => HabitController(ref),
);

class HabitController extends StateNotifier<AsyncValue<List<Habit>>> {
  final Ref ref;
  final HabitRepository _habitRepository = HabitRepository();
  HabitController(this.ref) : super(const AsyncValue.data([]));

  Future<void> getHabitsByOwner(String ownerId) async {
    state = const AsyncValue.loading();
    try {
      final habits = await _habitRepository.getHabitsByOwnerId(ownerId);
      state = AsyncValue.data(habits);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> getSharedHabits(String userId) async {
    state = const AsyncValue.loading();
    try {
      final habits = await _habitRepository.getSharedHabits(userId);
      state = AsyncValue.data(habits);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Habit?> getHabitById(String habitId) async {
    try {
      final habit = await _habitRepository.getHabitById(habitId);
      return habit;
    } catch (e) {
      // Handle error as needed
      return null;
    }
  }

  Future<void> createHabit(Habit habit) async {
    state = const AsyncValue.loading();
    try {
      await _habitRepository.createHabit(habit);
      // Refresh the list after creation
      final ownerId = habit.owner.id; // <-- FIXED
      final habits = await _habitRepository.getHabitsByOwnerId(ownerId);
      state = AsyncValue.data(habits);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateHabit(Habit habit) async {
    state = const AsyncValue.loading();
    try {
      await _habitRepository.updateHabit(habit);
      // Refresh the list after update
      final ownerId = habit.owner.id; // <-- FIXED
      final habits = await _habitRepository.getHabitsByOwnerId(ownerId);
      state = AsyncValue.data(habits);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteHabit(String habitId, String ownerId) async {
    state = const AsyncValue.loading();
    try {
      await _habitRepository.deleteHabit(habitId);
      // Refresh the list after deletion
      final habits = await _habitRepository.getHabitsByOwnerId(ownerId);
      state = AsyncValue.data(habits);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
