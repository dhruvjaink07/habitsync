import 'package:habitsync/features/auth/domain/user_model.dart';
import 'package:habitsync/features/auth/repository/auth_repository.dart';
import 'package:habitsync/services/profile_cache_service.dart';
import 'package:riverpod/riverpod.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<User?>>(
        (ref) => AuthController(ref));

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final Ref ref;
  final AuthRepository _authRepository = AuthRepository();

  AuthController(this.ref) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.login(email, password);
      final user = await _authRepository.getProfile();

      await ProfileCacheService.cacheUserProfile(user);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(String username, String name, String email, String bio,
      String password) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.register(username, name, email, bio, password);
      final user = await _authRepository.getProfile();
      await ProfileCacheService.cacheUserProfile(user);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.logout();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.getProfile();
      await ProfileCacheService.cacheUserProfile(user);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
