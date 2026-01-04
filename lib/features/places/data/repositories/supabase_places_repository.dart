import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/place_with_active_members.dart';

class SupabasePlacesRepository {
  final SupabaseClient _client;

  SupabasePlacesRepository(this._client);

  Future<void> createPlace(Place place) async {
    await _client.from('places').upsert({
      'id': place.id,
      'name': place.name,
      'latitude': place.latitude,
      'longitude': place.longitude,
      'address': place.address,
      'created_by': place.createdBy,
      'updated_at': place.updatedAt.toIso8601String(),
    });
  }

  /// Fetch active members at each place
  /// Returns a map of place_id -> list of ActiveMember
  Future<Map<String, List<ActiveMember>>> fetchActiveMembersAtPlaces(
    List<String> placeIds,
  ) async {
    if (placeIds.isEmpty) {
      return {};
    }

    // 1. Get active check-ins at these places (fetch minimal data first)
    final checkInsResponse = await _client
        .from('check_ins')
        .select('*') // Select all to avoid column name errors
        .inFilter('place_id', placeIds)
        .isFilter('checked_out_at', null);

    final checkIns = List<Map<String, dynamic>>.from(checkInsResponse as List);

    if (checkIns.isEmpty) {
      return {};
    }

    // 2. Collect unique user IDs
    final userIds = checkIns
        .map((c) => c['user_id'] as String)
        .toSet()
        .toList();

    // 3. Fetch profiles for these users
    final profilesResponse = await _client
        .from('profiles')
        .select('*') // Select all to mimic HomeRepository
        .inFilter('id', userIds);

    final profiles = List<Map<String, dynamic>>.from(profilesResponse as List);
    final profilesMap = {for (final p in profiles) p['id'] as String: p};

    // 4. Group by place_id and construct ActiveMember objects
    final Map<String, List<ActiveMember>> result = {};

    for (final checkIn in checkIns) {
      final placeId = checkIn['place_id'] as String;
      final userId = checkIn['user_id'] as String;
      final profile = profilesMap[userId];

      // If profile missing (deleted user or RLS block), skip or show placeholder?
      if (profile == null) continue;

      final checkedInAt = DateTime.tryParse(
        checkIn['checked_in_at'] as String? ?? '',
      );

      final activeMember = ActiveMember(
        id: userId,
        username: profile['username'] as String,
        displayName: profile['display_name'] as String?,
        avatarUrl: profile['avatar_url'] as String?,
        checkedInAt: checkedInAt,
      );

      if (!result.containsKey(placeId)) {
        result[placeId] = [];
      }

      // Avoid duplicates
      if (!result[placeId]!.any((m) => m.id == activeMember.id)) {
        result[placeId]!.add(activeMember);
      }
    }

    return result;
  }

  Future<void> checkIn(String placeId, String userId) async {
    // Check out from any other active check-ins first (optional cleanliness)
    // For now, assuming server handles conflicts or we allow multiple (unlikely based on app type)
    await _client.from('check_ins').insert({
      'user_id': userId,
      'place_id': placeId,
      'checked_in_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> checkOut(String placeId, String userId) async {
    await _client
        .from('check_ins')
        .update({'checked_out_at': DateTime.now().toIso8601String()})
        .match({'user_id': userId, 'place_id': placeId})
        .isFilter('checked_out_at', null); // Only checkout active ones
  }
}
