import 'dart:convert';
import 'package:habitsync/features/auth/domain/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCacheService {
  static const _key = 'user_profile';

  static Future<void> cacheUserProfile(User profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(profile.toJson()));
  }

  static Future<User?> getCachedUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr != null) {
      return User.fromJson(jsonDecode(jsonStr));
    }
    return null;
  }

  static Future<void> clearCachedUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
