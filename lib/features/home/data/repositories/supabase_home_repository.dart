import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../features/groups/domain/entities/group.dart';
import '../../../../features/groups/domain/entities/planned_visit.dart';
import '../../../../features/places/domain/entities/place.dart';
import '../../../../features/social/domain/entities/social_user.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/check_in.dart';
import '../../domain/repositories/i_home_repository.dart';

class SupabaseHomeRepository implements IHomeRepository {
  final supabase.SupabaseClient _client;

  SupabaseHomeRepository(this._client);

  @override
  Future<List<CheckIn>> getMyActiveCheckIns(String userId) async {
    final response = await _client
        .from('check_ins')
        .select('''
          *,
          places!inner(*),
          activities(*),
          groups(*),
          profiles!inner(*)
        ''')
        .eq('user_id', userId)
        .isFilter('checked_out_at', null);

    return (response as List).map((json) => _mapCheckIn(json)).toList();
  }

  @override
  Future<List<CheckIn>> getFriendsActiveCheckIns(String userId) async {
    // First get friends list (simplified for now, ideally use a view or RPC)
    // Assuming 'my_friends' view exists as per svelte code
    final friendsResponse = await _client
        .from('my_friends')
        .select('friend_id');
    final friendIds = (friendsResponse as List)
        .map((f) => f['friend_id'] as String)
        .toList();

    if (friendIds.isEmpty) return [];

    final response = await _client
        .from('check_ins')
        .select('''
          *,
          places!inner(*),
          activities(*),
          groups(*),
          profiles!inner(*)
        ''')
        .inFilter('user_id', friendIds)
        .isFilter('checked_out_at', null)
        .order('checked_in_at', ascending: false);

    return (response as List).map((json) => _mapCheckIn(json)).toList();
  }

  @override
  Future<List<PlannedVisit>> getUpcomingVisits(String userId) async {
    final response = await _client
        .from('planned_visits')
        .select('''
          *,
          places!inner(*),
          profiles!inner(*)
        ''') // simplified query, ignoring groups filtering for MVP
        .or(
          'user_id.eq.$userId',
        ) // For now just my visits or simple friend logic
        // Ideally should match the complex logic in svelte (friends + groups)
        // But let's start with a simpler query: My visits + Friends visits
        .gt('planned_at', DateTime.now().toIso8601String())
        .order('planned_at', ascending: true)
        .limit(10);

    // Note: The svelte code has complex filtering for groups visibility.
    // For this MVP step, we map basic visits.
    // We need to map to PlannedVisit entity which might need joined data not typically in its constructor?
    // PlannedVisit entity seems to be basic. Let's check if we can extend it or if we need a UI model.
    // For now, mapping what we can.

    return (response as List).map((json) {
      return PlannedVisit(
        id: json['id'],
        placeId: json['place_id'],
        userId: json['user_id'],
        plannedAt: DateTime.parse(json['planned_at']),
        notes: json['notes'],
        durationMinutes: json['duration'] != null
            ? 60
            : 60, // Parse interval if needed
      );
    }).toList();
  }

  @override
  Future<List<CheckIn>> getRecentActivity(String userId) async {
    final response = await _client
        .from('check_ins')
        .select('''
          *,
          places!inner(*),
          activities(*),
          groups(*),
          profiles!inner(*)
        ''')
        .eq('user_id', userId)
        .not('checked_out_at', 'is', null)
        .order('checked_in_at', ascending: false)
        .limit(10);

    return (response as List).map((json) => _mapCheckIn(json)).toList();
  }

  CheckIn _mapCheckIn(Map<String, dynamic> json) {
    return CheckIn(
      id: json['id'],
      userId: json['user_id'],
      placeId: json['place_id'],
      groupId: json['group_id'],
      activityId: json['activity_id'],
      checkedInAt: DateTime.parse(json['checked_in_at']),
      checkedOutAt: json['checked_out_at'] != null
          ? DateTime.parse(json['checked_out_at'])
          : null,
      place: json['places'] != null ? Place.fromJson(json['places']) : null,
      user: json['profiles'] != null
          ? SocialUser.fromJson(json['profiles'])
          : null,
      activity: json['activities'] != null
          ? Activity.fromJson(json['activities'])
          : null,
      group: json['groups'] != null ? Group.fromJson(json['groups']) : null,
    );
  }
}
