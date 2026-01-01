import '../entities/group.dart';
import '../entities/group_with_stats.dart';
import '../entities/planned_visit.dart';

class GroupPlaceData {
  final String placeId;
  final double radius;
  final String? description;
  final String placeType;

  const GroupPlaceData({
    required this.placeId,
    this.radius = 100.0,
    this.description,
    this.placeType = 'skatepark',
  });
}

abstract class IGroupsRepository {
  Future<List<Group>> getMyGroups(String userId);
  Future<List<GroupWithStats>> getMyGroupsWithStats(String userId);
  Future<Group?> getGroup(String groupId);
  Future<void> createGroup(
    Group group,
    List<GroupPlaceData> initialPlaces, [
    List<String> inviteeIds = const [],
  ]);
  Future<void> updateGroup(Group group);
  Future<void> deleteGroup(String groupId);
  Future<void> joinGroup(String groupId, String userId);
  Future<void> leaveGroup(String groupId, String userId);
  Future<List<Group>> getGroupsForPlace(String placeId);
  Future<List<PlannedVisit>> getPlannedVisitsForPlace(String placeId);
}
