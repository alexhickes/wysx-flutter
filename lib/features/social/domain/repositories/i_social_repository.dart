import '../entities/friend_request.dart';
import '../entities/social_user.dart';

abstract class ISocialRepository {
  Stream<List<SocialUser>> getFriends();
  Stream<List<FriendRequest>> getIncomingRequests();
  Stream<List<FriendRequest>> getSentRequests();

  Future<void> sendFriendRequest(String username);
  Future<void> acceptFriendRequest(String userId);
  Future<void> rejectFriendRequest(String userId);
  Future<void> removeFriend(String userId);
  Future<void> blockUser(String userId);
  Future<void> unblockUser(String userId);

  // Note: This might require backend changes to support per-friend sharing
  Future<void> toggleLocationSharing(String friendId, bool enabled);

  Future<List<SocialUser>> searchUsers(String query);
}
