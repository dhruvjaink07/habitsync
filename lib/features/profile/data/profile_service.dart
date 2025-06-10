import 'package:dio/dio.dart';
import 'package:habitsync/core/network/dio_service.dart';
import 'package:habitsync/features/auth/domain/user_model.dart';

class ProfileService {
  final Dio dio = DioService().dio;

  Future<List<User>> searchProfile(String query) async {
    try {
      final response =
          await dio.get('/user/search', queryParameters: {'q': query});
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((item) => User.fromJson(item)).toList();
      } else {
        print('Failed to search profiles: ${response.data}');
        return [];
      }
    } catch (e) {
      print('Error searching profiles: $e');
      return [];
    }
  }

  Future<void> updateProfile(User user) async {
    try {
      final response = await dio.put('/user/update', data: user.toJson());
      if (response.statusCode == 200) {
        print('Profile updated successfully');
      } else {
        print('Failed to update profile: ${response.data}');
      }
    } catch (e) {
      print('Error updating profile: $e');
      throw e; // Re-throw the error for further handling if needed
    }
  }

  Future<void> deleteProfile() async {
    try {
      await dio.delete('/user/delete');
    } catch (e) {
      print('Error deleting profile: $e');
      throw e;
    }
  }
}
