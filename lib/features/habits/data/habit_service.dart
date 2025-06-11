import 'package:dio/dio.dart';
import 'package:habitsync/core/network/dio_service.dart';
import 'package:habitsync/features/habits/domain/habit_model.dart';

class HabitService {
  final Dio _dio = DioService().dio;

  Future<void> createHabit(Habit habit) async {
    try {
      final response = await _dio.post('/habit', data: habit.toJson());
      if (response.statusCode != 201) {
        throw Exception('Failed to create habit: ${response.data}');
      }
    } catch (e) {
      print('Error creating habit: $e');
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      final response =
          await _dio.put('/habit/${habit.id}', data: habit.toJson());
      if (response.statusCode != 200) {
        throw Exception('Failed to update habit: ${response.data}');
      }
    } catch (e) {
      print('Error updating habit: $e');
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      final response = await _dio.delete('/habit/$habitId');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete habit: ${response.data}');
      }
    } catch (e) {
      print('Error deleting habit: $e');
    }
  }

  Future<List<Habit>> getHabits() async {
    try {
      final response = await _dio.get('/habit');
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((item) => Habit.fromJson(item)).toList();
      } else {
        print('Failed to fetch habits: ${response.data}');
        return [];
      }
    } catch (e) {
      print('Error fetching habits: $e');
      return [];
    }
  }

  Future<Habit> getHabitById(String habitId) async {
    try {
      final response = await _dio.get('/habit/$habitId');
      if (response.statusCode == 200) {
        return Habit.fromJson(response.data);
      } else {
        print('Failed to fetch habit: ${response.data}');
        throw Exception('Habit not found');
      }
    } catch (e) {
      print('Error fetching habit by ID: $e');
      rethrow;
    }
  }

  Future<List<Habit>> getHabitsByOwner(String ownerId) async {
    try {
      final response = await _dio.get('/habit/user/$ownerId');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((item) => Habit.fromJson(item))
            .toList();
      } else {
        print('Unable to fetch habits by owner: ${response.data}');
        return [];
      }
    } catch (e) {
      print('Failed to fetch habits by owner: $e');
      return [];
    }
  }

  Future<List<Habit>> getSharedHabits(String userId) async {
    try {
      final response = await _dio.get('/habit/collaborative/$userId');
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((item) => Habit.fromJson(item)).toList();
      } else {
        print('Failed to fetch shared habits: ${response.data}');
        return [];
      }
    } catch (e) {
      print('Error fetching shared habits: $e');
      return [];
    }
  }
}
