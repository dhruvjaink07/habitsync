import 'package:habitsync/features/auth/controller/auth_controller.dart';
import 'package:habitsync/features/auth/domain/user_model.dart';
import 'package:habitsync/features/profile/repository/profile_repositoy.dart';
import 'package:riverpod/riverpod.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<User?>>(
        (ref) => ProfileController(ref));

class ProfileController extends StateNotifier<AsyncValue<User?>> {
  final Ref ref;
  final ProfileRepositoy _profileRepositoy = ProfileRepositoy();

  ProfileController(this.ref) : super(const AsyncValue.data(null));

  Future<void> searchProfile(String query) async {
    state = const AsyncValue.loading();
    try {
      final profiles = await _profileRepositoy.searchProfile(query);
      if (profiles.isNotEmpty) {
        state = AsyncValue.data(profiles.first);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile(User user) async {
    state = const AsyncValue.loading();
    try {
      await _profileRepositoy.updateProfile(user);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteProfile() async {
    state = const AsyncValue.loading();
    try {
      await _profileRepositoy.deleteProfile();
      await ref.read(authControllerProvider.notifier).logout();
      ref.invalidate(authControllerProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
