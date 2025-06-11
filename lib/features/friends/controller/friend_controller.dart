import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitsync/features/auth/domain/user_model.dart';
import 'package:habitsync/features/friends/repository/friend_repository.dart';

final friendControllerProvider =
    StateNotifierProvider<FriendController, AsyncValue<List<User>>>(
        (ref) => FriendController(ref));

// New provider for friend requests
final friendRequestsProvider =
    StateNotifierProvider<FriendRequestsController, AsyncValue<List<User>>>(
        (ref) => FriendRequestsController(ref));

final searchFriendsProvider =
    StateNotifierProvider<SearchFriendsController, AsyncValue<List<User>>>(
  (ref) => SearchFriendsController(ref),
);

class FriendController extends StateNotifier<AsyncValue<List<User>>> {
  final Ref ref;
  final FriendRepository _repository = FriendRepository();

  FriendController(this.ref) : super(const AsyncValue.loading()) {
    getFriends();
  }

  Future<void> getFriends() async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.getFriends();
      final friends =
          (response.data as List).map((json) => User.fromJson(json)).toList();
      state = AsyncValue.data(friends);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeFriend(String friendId) async {
    try {
      await _repository.removeFriend(friendId);
      await getFriends();
    } catch (e) {}
  }

  Future<void> sendFriendRequest(String toUserId) async {
    try {
      await _repository.sendFriendRequest(toUserId);
      // Optionally show a snackbar or update UI
    } catch (e) {
      // Optionally handle error
    }
  }
}

// Friend Requests Controller
class FriendRequestsController extends StateNotifier<AsyncValue<List<User>>> {
  final Ref ref;
  final FriendRepository _repository = FriendRepository();

  FriendRequestsController(this.ref) : super(const AsyncValue.loading()) {
    getFriendRequests();
  }

  Future<void> getFriendRequests() async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.getFriendRequests();
      final requests =
          (response.data as List).map((json) => User.fromJson(json)).toList();
      state = AsyncValue.data(requests);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> acceptFriendRequest(String fromUserId) async {
    try {
      await _repository.acceptFriendRequest(fromUserId);
      await getFriendRequests();
      // Optionally refresh friends list
      ref.read(friendControllerProvider.notifier).getFriends();
    } catch (e) {}
  }

  Future<void> rejectFriendRequest(String fromUserId) async {
    try {
      await _repository.rejectFriendRequest(fromUserId);
      await getFriendRequests();
    } catch (e) {}
  }
}

// Search Friends Controller
class SearchFriendsController extends StateNotifier<AsyncValue<List<User>>> {
  final Ref ref;
  final FriendRepository _repository = FriendRepository();

  SearchFriendsController(this.ref) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final response = await _repository.searchFriends(query);
      final results =
          (response.data as List).map((json) => User.fromJson(json)).toList();
      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
