import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/group.dart';
import '../../domain/repositories/i_groups_repository.dart';

class SupabaseGroupsRepository {
  final SupabaseClient _client;

  SupabaseGroupsRepository(this._client);

  Future<void> createGroup(
    Group group,
    List<GroupPlaceData> initialPlaces, [
    List<String> inviteeIds = const [],
  ]) async {
    // 1. Insert Group
    await _client.from('groups').insert({
      'id': group.id,
      'name': group.name,
      'description': group.description,
      'created_by': group.createdBy,
      'is_public': group.isPublic,
      'requires_approval': group.requiresApproval,
      'auto_checkin_enabled': group.autoCheckinEnabled,
      'notification_enabled': group.notificationEnabled,
      'created_at': group.createdAt.toIso8601String(),
    });

    // 2. Insert Group Member (Admin)
    // Note: Supabase might have a trigger to add creator as admin, but doing it explicitly is safer if not.
    // Checking prototype: prototype does it explicitly in some cases or relies on RLS/Triggers.
    // Let's assume we need to add it.
    await _client.from('group_members').insert({
      'group_id': group.id,
      'user_id': group.createdBy,
      'role': 'admin',
      'joined_at': DateTime.now().toIso8601String(),
    });

    // 3. Insert Group Places
    if (initialPlaces.isNotEmpty) {
      final placesData = initialPlaces.asMap().entries.map((entry) {
        final index = entry.key;
        final place = entry.value;
        return {
          'group_id': group.id,
          'place_id': place.placeId,
          'is_primary': index == 0,
          'display_order': index,
          'radius': place.radius.round(),
          'description': place.description,
          'place_type': place.placeType.split(','),
          'added_by': group.createdBy,
          'added_at': DateTime.now().toIso8601String(),
        };
      }).toList();

      await _client.from('group_places').insert(placesData);
    }

    // 4. Insert Group Invitations
    if (inviteeIds.isNotEmpty) {
      final invitationsData = inviteeIds.map((inviteeId) {
        return {
          'group_id': group.id,
          'inviter_id': group.createdBy,
          'invitee_id': inviteeId,
          'status': 'pending',
        };
      }).toList();

      await _client.from('group_invitations').insert(invitationsData);
    }
  }

  Future<List<Group>> fetchMyGroups(String userId) async {
    // Fetch groups where the user is a member
    final response = await _client
        .from('groups')
        .select('*, group_members!inner(user_id)')
        .eq('group_members.user_id', userId);

    final data = response as List<dynamic>;

    return data.map((json) {
      return Group(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        createdBy: json['created_by'],
        createdAt: DateTime.parse(json['created_at']),
        isPublic: json['is_public'] ?? false,
        requiresApproval: json['requires_approval'] ?? false,
        autoCheckinEnabled: json['auto_checkin_enabled'] ?? false,
        notificationEnabled: json['notification_enabled'] ?? true,
      );
    }).toList();
  }

  Future<List<Map<String, dynamic>>> fetchMyPendingInvitations(
    String userId,
  ) async {
    final response = await _client
        .from('group_invitations')
        .select(
          '*, groups(*, group_places(*, places(*))), inviter:profiles!group_invitations_inviter_id_fkey(*)',
        )
        .eq('invitee_id', userId)
        .eq('status', 'pending');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> acceptInvitation(String invitationId) async {
    await _client.rpc(
      'accept_group_invitation',
      params: {'p_invitation_id': invitationId},
    );
  }

  Future<void> declineInvitation(String invitationId) async {
    await _client.rpc(
      'decline_group_invitation',
      params: {'p_invitation_id': invitationId},
    );
  }

  Future<Group> fetchGroupDetails(String groupId) async {
    final response = await _client
        .from('groups')
        .select('*')
        .eq('id', groupId)
        .single();

    final json = response;
    return Group(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      isPublic: json['is_public'] ?? false,
      requiresApproval: json['requires_approval'] ?? false,
      autoCheckinEnabled: json['auto_checkin_enabled'] ?? false,
      notificationEnabled: json['notification_enabled'] ?? true,
    );
  }

  Future<List<Map<String, dynamic>>> fetchGroupMembers(String groupId) async {
    final response = await _client
        .from('group_members')
        .select('*, profiles(*)')
        .eq('group_id', groupId)
        .order('joined_at', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchGroupPlaces(String groupId) async {
    final response = await _client
        .from('group_places')
        .select('*, places(*)')
        .eq('group_id', groupId)
        .order('display_order', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addPlaceToGroup(
    String groupId,
    String placeId,
    String userId,
  ) async {
    await _client.from('group_places').insert({
      'group_id': groupId,
      'place_id': placeId,
      'added_by': userId,
      'added_at': DateTime.now().toIso8601String(),
      'place_type': ['other'], // Default or fetch from place
      'radius': 100, // Default
    });
  }

  Future<void> removePlaceFromGroup(String groupId, String placeId) async {
    await _client
        .from('group_places')
        .delete()
        .eq('group_id', groupId)
        .eq('place_id', placeId);
  }

  Future<void> updateGroupPlace(
    String groupId,
    String placeId, {
    double? radius,
    String? description,
    List<String>? placeType,
  }) async {
    final updates = <String, dynamic>{};
    if (radius != null) updates['radius'] = radius.round();
    if (description != null) updates['description'] = description;
    if (placeType != null) updates['place_type'] = placeType;

    if (updates.isEmpty) return;

    await _client
        .from('group_places')
        .update(updates)
        .eq('group_id', groupId)
        .eq('place_id', placeId);
  }

  Future<void> removeMemberFromGroup(String groupId, String userId) async {
    await _client
        .from('group_members')
        .delete()
        .eq('group_id', groupId)
        .eq('user_id', userId);
  }

  Future<void> updateMemberSettings(
    String groupId,
    String userId, {
    bool? shareLocation,
    bool? notificationsEnabled,
  }) async {
    final updates = <String, dynamic>{};
    if (shareLocation != null) updates['share_location'] = shareLocation;
    if (notificationsEnabled != null) {
      updates['notifications_enabled'] = notificationsEnabled;
    }

    if (updates.isEmpty) return;

    await _client
        .from('group_members')
        .update(updates)
        .eq('group_id', groupId)
        .eq('user_id', userId);
  }

  Future<void> leaveGroup(String groupId, String userId) async {
    await removeMemberFromGroup(groupId, userId);
  }

  Future<void> createPlannedVisit({
    required String groupId,
    required String placeId,
    required String userId,
    required DateTime startTime,
    required int durationMinutes,
    String? notes,
  }) async {
    // 1. Insert into planned_visits
    final visitResponse = await _client
        .from('planned_visits')
        .insert({
          'place_id': placeId,
          'user_id': userId,
          'planned_at': startTime.toIso8601String(),
          'notes': notes,
          'duration': '$durationMinutes minutes',
        })
        .select()
        .single();

    final visitId = visitResponse['id'];

    // 2. Link to group in planned_visit_groups
    await _client.from('planned_visit_groups').insert({
      'planned_visit_id': visitId,
      'group_id': groupId,
    });
  }

  Future<List<Map<String, dynamic>>> fetchPlannedVisits(String groupId) async {
    final response = await _client
        .from('planned_visits')
        .select(
          '*, places(*), profiles(*), planned_visit_groups!inner(group_id)',
        )
        .eq('planned_visit_groups.group_id', groupId)
        .gte('planned_at', DateTime.now().toIso8601String())
        .order('planned_at', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> inviteMembersToGroup(
    String groupId,
    String inviterId,
    List<String> inviteeIds,
  ) async {
    if (inviteeIds.isEmpty) return;

    final invitationsData = inviteeIds.map((inviteeId) {
      return {
        'group_id': groupId,
        'inviter_id': inviterId,
        'invitee_id': inviteeId,
        'status': 'pending',
      };
    }).toList();

    await _client.from('group_invitations').insert(invitationsData);
  }

  Future<void> updateGroup(String groupId, Map<String, dynamic> updates) async {
    await _client.from('groups').update(updates).eq('id', groupId);
  }

  /// Fetch statistics for a group showing how many friends are at how many places
  Future<Map<String, int>> fetchGroupStats(
    String groupId,
    String currentUserId,
  ) async {
    // Get all group members (friends in this group)
    final membersResponse = await _client
        .from('group_members')
        .select('user_id')
        .eq('group_id', groupId)
        .neq('user_id', currentUserId); // Exclude current user

    final memberIds = (membersResponse as List<dynamic>)
        .map((m) => m['user_id'] as String)
        .toList();

    if (memberIds.isEmpty) {
      return {'activeFriends': 0, 'activePlaces': 0};
    }

    // Get active check-ins for these members at group places
    final checkInsResponse = await _client
        .from('check_ins')
        .select('user_id, place_id, group_id')
        .eq('group_id', groupId)
        .inFilter('user_id', memberIds)
        .isFilter('checked_out_at', null);

    final checkIns = checkInsResponse as List<dynamic>;

    // Count unique friends and places
    final uniqueFriends = <String>{};
    final uniquePlaces = <String>{};

    for (final checkIn in checkIns) {
      uniqueFriends.add(checkIn['user_id'] as String);
      uniquePlaces.add(checkIn['place_id'] as String);
    }

    return {
      'activeFriends': uniqueFriends.length,
      'activePlaces': uniquePlaces.length,
    };
  }

  Future<List<Map<String, dynamic>>> fetchPlannedVisitsForPlace(
    String placeId,
  ) async {
    final response = await _client
        .from('planned_visits')
        .select('*, profiles(*)')
        .eq('place_id', placeId)
        .gte('planned_at', DateTime.now().toIso8601String())
        .order('planned_at', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }
}
