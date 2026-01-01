import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/friend_request.dart';
import '../../domain/entities/social_user.dart';
import '../../domain/repositories/i_social_repository.dart';

class SupabaseSocialRepository implements ISocialRepository {
  final SupabaseClient _client;

  SupabaseSocialRepository(this._client);

  String get _currentUserId => _client.auth.currentUser!.id;

  List<String> _normalizeUserIds(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0
        ? [userId1, userId2]
        : [userId2, userId1];
  }

  @override
  Stream<List<SocialUser>> getFriends() {
    return _client
        .from('my_friends')
        .stream(primaryKey: ['friend_id'])
        .map(
          (data) => data.map((json) {
            return SocialUser(
              id: json['friend_id'] as String,
              username: json['username'] as String,
              displayName: json['display_name'] as String?,
              // TODO: Add avatar_url to my_friends view or fetch separately
              avatarUrl: null,
              isSharingLocation: json['is_sharing'] as bool? ?? false,
              // TODO: Parse location data if available in view
              locationName: json['location_name'] as String?,
              placeId: json['place_id'] as String?,
            );
          }).toList(),
        );
  }

  @override
  Stream<List<FriendRequest>> getIncomingRequests() {
    return _client
        .from('pending_requests_received')
        .stream(primaryKey: ['requester_id'])
        .map(
          (data) => data.map((json) {
            return FriendRequest(
              userId: json['requester_id'] as String,
              username: json['requester_username'] as String,
              displayName: json['requester_display_name'] as String?,
              createdAt: DateTime.parse(json['created_at'] as String),
            );
          }).toList(),
        );
  }

  @override
  Stream<List<FriendRequest>> getSentRequests() {
    return _client
        .from('pending_requests_sent')
        .stream(primaryKey: ['recipient_id'])
        .map(
          (data) => data.map((json) {
            return FriendRequest(
              userId: json['recipient_id'] as String,
              username: json['recipient_username'] as String,
              displayName: json['recipient_display_name'] as String?,
              createdAt: DateTime.parse(json['created_at'] as String),
            );
          }).toList(),
        );
  }

  @override
  Future<void> sendFriendRequest(String username) async {
    // 1. Find user by username
    final response = await _client
        .from('profiles')
        .select('id')
        .eq('username', username)
        .maybeSingle();

    if (response == null) {
      throw Exception('User not found');
    }

    final friendId = response['id'] as String;
    if (friendId == _currentUserId) {
      throw Exception("You can't add yourself as a friend");
    }

    // 2. Normalize IDs
    final ids = _normalizeUserIds(_currentUserId, friendId);
    final userId1 = ids[0];
    final userId2 = ids[1];

    // 3. Check existing friendship
    final existing = await _client
        .from('friendships')
        .select()
        .eq('user_id_1', userId1)
        .eq('user_id_2', userId2)
        .maybeSingle();

    if (existing != null) {
      final status = existing['status'];
      if (status == 'accepted') throw Exception('Already friends');
      if (status == 'pending') throw Exception('Friend request already sent');

      // If rejected, update to pending
      await _client
          .from('friendships')
          .update({
            'status': 'pending',
            'initiated_by': _currentUserId,
            'created_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id_1', userId1)
          .eq('user_id_2', userId2);
      return;
    }

    // 4. Insert new request
    await _client.from('friendships').insert({
      'user_id_1': userId1,
      'user_id_2': userId2,
      'initiated_by': _currentUserId,
      'status': 'pending',
    });
  }

  @override
  Future<void> acceptFriendRequest(String requesterId) async {
    final ids = _normalizeUserIds(_currentUserId, requesterId);

    await _client
        .from('friendships')
        .update({
          'status': 'accepted',
          'accepted_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id_1', ids[0])
        .eq('user_id_2', ids[1])
        .eq('status', 'pending');
  }

  @override
  Future<void> rejectFriendRequest(String requesterId) async {
    final ids = _normalizeUserIds(_currentUserId, requesterId);

    await _client
        .from('friendships')
        .update({'status': 'rejected'})
        .eq('user_id_1', ids[0])
        .eq('user_id_2', ids[1])
        .eq('status', 'pending');
  }

  @override
  Future<void> removeFriend(String friendId) async {
    final ids = _normalizeUserIds(_currentUserId, friendId);

    await _client
        .from('friendships')
        .delete()
        .eq('user_id_1', ids[0])
        .eq('user_id_2', ids[1]);
  }

  @override
  Future<void> blockUser(String userId) async {
    // Remove friendship first
    await removeFriend(userId);

    await _client.from('user_blocks').insert({
      'blocker_id': _currentUserId,
      'blocked_id': userId,
    });
  }

  @override
  Future<void> unblockUser(String userId) async {
    await _client
        .from('user_blocks')
        .delete()
        .eq('blocker_id', _currentUserId)
        .eq('blocked_id', userId);
  }

  @override
  Future<void> toggleLocationSharing(String friendId, bool enabled) async {
    // TODO: Implement per-friend sharing logic when backend supports it
    // For now, this is a placeholder or could toggle global sharing
    // await _client.from('profiles').update({'is_sharing': enabled}).eq('id', _currentUserId);
    throw UnimplementedError(
      'Per-friend location sharing not yet supported by backend',
    );
  }

  @override
  Future<List<SocialUser>> searchUsers(String query) async {
    if (query.length < 2) return [];

    final response = await _client
        .from('profiles')
        .select('id, username, display_name')
        .ilike('username', '%$query%')
        .neq('id', _currentUserId)
        .limit(10);

    final List<dynamic> data = response as List<dynamic>;

    // We need to filter out existing friends and pending requests.
    // Ideally this should be done in the DB, but for now we'll do it client-side
    // to match the prototype logic, or we can fetch friends IDs first.
    // For efficiency, let's just return the profiles and let the UI or Provider filter
    // (or filter here if we have easy access to friend IDs).
    // The Svelte code filters client-side using the already loaded friends list.
    // Here, we don't have the friends list cached in the repo.
    // So we will return all matches and let the UI/Provider filter,
    // OR we can fetch friend IDs here. Fetching here is safer.

    // Fetch friend IDs and pending request IDs to exclude
    final friendsResponse = await _client
        .from('friendships')
        .select('user_id_1, user_id_2')
        .or('user_id_1.eq.$_currentUserId,user_id_2.eq.$_currentUserId');

    final excludedIds = <String>{_currentUserId};
    for (final f in friendsResponse) {
      excludedIds.add(f['user_id_1'] as String);
      excludedIds.add(f['user_id_2'] as String);
    }

    return data
        .where((json) => !excludedIds.contains(json['id']))
        .map(
          (json) => SocialUser(
            id: json['id'] as String,
            username: json['username'] as String,
            displayName: json['display_name'] as String?,
            avatarUrl: null, // Schema doesn't have avatar_url
          ),
        )
        .toList();
  }
}
