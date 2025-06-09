import 'package:habitsync/features/auth/data/auth_service.dart';
import 'package:habitsync/features/auth/domain/user_model.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<void> login(String email, String password) async {
    try {
      await _authService.login(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      await _authService.register(username, email, password);
    } catch (e) {
      rethrow; // Propagate the error to the caller
    }
  }

  Future<User> getProfile() async {
    try {
      return await _authService.getProfile();
    } catch (e) {
      rethrow; // Propagate the error to the caller
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      rethrow; // Propagate the error to the caller
    }
  }
}
