import 'package:habitsync/features/friends/data/friend_service.dart';
import 'package:dio/dio.dart';

class FriendRepository {
  final FriendService _service = FriendService();

  Future<Response> sendFriendRequest(String toUserId) {
    return _service.sendFriendRequest(toUserId);
  }

  Future<Response> getFriendRequests() {
    return _service.getFriendRequests();
  }

  Future<Response> acceptFriendRequest(String fromUserId) {
    return _service.acceptFriendRequest(fromUserId);
  }

  Future<Response> rejectFriendRequest(String fromUserId) {
    return _service.rejectFriendRequest(fromUserId);
  }

  Future<Response> removeFriend(String friendId) {
    return _service.removeFriend(friendId);
  }

  Future<Response> getFriends() {
    return _service.getFriends();
  }

  Future<Response> searchFriends(String query) {
    return _service.searchFriends(query);
  }
}
