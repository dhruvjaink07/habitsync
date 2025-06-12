import 'package:dio/dio.dart';
import 'package:habitsync/core/network/dio_service.dart';
import 'package:habitsync/features/auth/domain/user_model.dart';
import 'package:habitsync/services/profile_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = DioService().dio;

  Future<void> login(String email, String password) async {
    final res = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    final token = res.data['token'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    // No need to parse user here
  }

  Future<void> register(String username, String name, String email, String bio,
      String password) async {
    final res = await _dio.post('/auth/register', data: {
      'username': username,
      'name': name,
      'email': email,
      'bio': bio,
      'password': password,
    });

    final token = res.data['token'];
    final userId = res.data['userId'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    await prefs.setString('userId', userId);
  }

  Future<User> getProfile() async {
    final res = await _dio.get('/user/me');
    print('Profile response: ${res.data}');
    return User.fromJson(
        res.data); // Ensure this matches the API response structure
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userId');
    await ProfileCacheService.clearCachedUserProfile();
  }
}
