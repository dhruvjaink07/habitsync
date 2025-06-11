import 'package:dio/dio.dart';
import 'package:habitsync/core/network/dio_service.dart';

class FriendService {
  final Dio _dio = DioService().dio;

  // Send a Friend Request
  Future<Response> sendFriendRequest(String userId) async {
    return await _dio.post(
      '/friends/request',
      data: {'toUserId': userId},
    );
  }

  // Get Incoming Friend Requests
  Future<Response> getFriendRequests() async {
    return await _dio.get('/friends/requests');
  }

  //  Accept a Friend Request
  Future<Response> acceptFriendRequest(String fromUserId) async {
    return await _dio.post('/friends/accept', data: {'fromUserId': fromUserId});
  }

  // Reject a Friend Request
  Future<Response> rejectFriendRequest(String fromUserId) async {
    return await _dio.post('/friends/reject', data: {'fromUserId': fromUserId});
  }

  // Remove a Friend
  Future<Response> removeFriend(String friendId) async {
    return await _dio.delete(
      '/friends/remove',
    );
  }

  // Get Friends List
  Future<Response> getFriends() async {
    return await _dio.get('/friends');
  }

  // Search users by query
  Future<Response> searchFriends(String query) async {
    return await _dio.get('/friends/search', queryParameters: {'q': query});
  }
}
