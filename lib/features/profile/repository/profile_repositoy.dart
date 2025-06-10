import 'package:habitsync/features/auth/domain/user_model.dart';
import 'package:habitsync/features/profile/data/profile_service.dart';

class ProfileRepositoy {
  final ProfileService _profileService = ProfileService();

  Future<List<User>> searchProfile(String query) async {
    try {
      return await _profileService.searchProfile(query);
    } catch (e) {
      rethrow; // Propagate the error to the caller
    }
  }

  Future<void> updateProfile(User user) async {
    try {
      await _profileService.updateProfile(user);
    } catch (e) {
      rethrow; // Propagate the error to the caller
    }
  }

  Future<void> deleteProfile() async {
    try {
      await _profileService.deleteProfile();
    } catch (e) {
      rethrow; // Propagate the error to the caller
    }
  }
}
