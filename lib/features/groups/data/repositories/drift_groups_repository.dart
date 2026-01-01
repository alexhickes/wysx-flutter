import 'package:drift/drift.dart';
import '../../../../core/services/app_database.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/group_with_stats.dart';
import '../../domain/entities/planned_visit.dart';
import '../../domain/repositories/i_groups_repository.dart';
import 'supabase_groups_repository.dart';

class DriftGroupsRepository implements IGroupsRepository {
  final AppDatabase _db;
  final SupabaseGroupsRepository? _supabaseRepository;

  DriftGroupsRepository(
    this._db, {
    SupabaseGroupsRepository? supabaseRepository,
  }) : _supabaseRepository = supabaseRepository;

  @override
  Future<List<Group>> getMyGroups(String userId) async {
    // Join groups with group_members to find groups where user is a member
    final query = _db.select(_db.groupsTable).join([
      innerJoin(
        _db.groupMembersTable,
        _db.groupMembersTable.groupId.equalsExp(_db.groupsTable.id),
      ),
    ]);

    query.where(_db.groupMembersTable.userId.equals(userId));

    final rows = await query.map((row) => row.readTable(_db.groupsTable)).get();

    return rows
        .map(
          (row) => Group(
            id: row.id,
            name: row.name,
            description: row.description,
            createdBy: row.createdBy,
            createdAt: row.createdAt,
            isPublic: row.isPublic,
            requiresApproval: row.requiresApproval,
            autoCheckinEnabled: row.autoCheckinEnabled,
            notificationEnabled: row.notificationEnabled,
          ),
        )
        .toList();
  }

  @override
  Future<List<GroupWithStats>> getMyGroupsWithStats(String userId) async {
    // First get all groups
    final groups = await getMyGroups(userId);

    // If no Supabase repository, return groups with zero stats
    if (_supabaseRepository == null) {
      return groups
          .map(
            (group) => GroupWithStats(
              group: group,
              activeFriendsCount: 0,
              activePlacesCount: 0,
            ),
          )
          .toList();
    }

    // Fetch stats for each group from Supabase
    final groupsWithStats = <GroupWithStats>[];
    for (final group in groups) {
      try {
        final stats = await _supabaseRepository.fetchGroupStats(
          group.id,
          userId,
        );
        groupsWithStats.add(
          GroupWithStats(
            group: group,
            activeFriendsCount: stats['activeFriends'] ?? 0,
            activePlacesCount: stats['activePlaces'] ?? 0,
          ),
        );
      } catch (e) {
        print('Error fetching stats for group ${group.id}: $e');
        // Add group with zero stats on error
        groupsWithStats.add(
          GroupWithStats(
            group: group,
            activeFriendsCount: 0,
            activePlacesCount: 0,
          ),
        );
      }
    }

    return groupsWithStats;
  }

  @override
  Future<Group?> getGroup(String groupId) async {
    final row = await (_db.select(
      _db.groupsTable,
    )..where((tbl) => tbl.id.equals(groupId))).getSingleOrNull();

    if (row == null) return null;

    return Group(
      id: row.id,
      name: row.name,
      description: row.description,
      createdBy: row.createdBy,
      createdAt: row.createdAt,
      isPublic: row.isPublic,
      requiresApproval: row.requiresApproval,
      autoCheckinEnabled: row.autoCheckinEnabled,
      notificationEnabled: row.notificationEnabled,
    );
  }

  @override
  Future<void> createGroup(
    Group group,
    List<GroupPlaceData> initialPlaces, [
    List<String> inviteeIds = const [],
  ]) async {
    await _db.transaction(() async {
      // 1. Create the group
      await _db
          .into(_db.groupsTable)
          .insert(
            GroupsTableCompanion(
              id: Value(group.id),
              name: Value(group.name),
              description: Value(group.description),
              createdBy: Value(group.createdBy),
              createdAt: Value(group.createdAt),
              isPublic: Value(group.isPublic),
              requiresApproval: Value(group.requiresApproval),
              autoCheckinEnabled: Value(group.autoCheckinEnabled),
              notificationEnabled: Value(group.notificationEnabled),
            ),
          );

      // 2. Add creator as admin
      await _db
          .into(_db.groupMembersTable)
          .insert(
            GroupMembersTableCompanion(
              groupId: Value(group.id),
              userId: Value(group.createdBy),
              role: const Value('admin'),
              joinedAt: Value(DateTime.now()),
            ),
          );

      // 3. Add initial places
      for (var i = 0; i < initialPlaces.length; i++) {
        final placeData = initialPlaces[i];
        await _db
            .into(_db.groupPlacesTable)
            .insert(
              GroupPlacesTableCompanion(
                groupId: Value(group.id),
                placeId: Value(placeData.placeId),
                isPrimary: Value(i == 0), // First one is primary
                displayOrder: Value(i),
                radius: Value(placeData.radius),
                description: Value(placeData.description),
                placeType: Value(placeData.placeType),
              ),
            );
      }
    });

    // 4. Sync to Supabase
    if (_supabaseRepository != null) {
      try {
        await _supabaseRepository.createGroup(group, initialPlaces, inviteeIds);
        // TODO: Update sync status if we had one on groups table
      } catch (e) {
        print('Error syncing group to Supabase: $e');
        rethrow; // Rethrow to surface error to UI
      }
    }
  }

  @override
  Future<void> updateGroup(Group group) async {
    await (_db.update(
      _db.groupsTable,
    )..where((tbl) => tbl.id.equals(group.id))).write(
      GroupsTableCompanion(
        name: Value(group.name),
        description: Value(group.description),
        isPublic: Value(group.isPublic),
        requiresApproval: Value(group.requiresApproval),
        autoCheckinEnabled: Value(group.autoCheckinEnabled),
        notificationEnabled: Value(group.notificationEnabled),
      ),
    );
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    await (_db.delete(
      _db.groupsTable,
    )..where((tbl) => tbl.id.equals(groupId))).go();
  }

  @override
  Future<void> joinGroup(String groupId, String userId) async {
    await _db
        .into(_db.groupMembersTable)
        .insert(
          GroupMembersTableCompanion(
            groupId: Value(groupId),
            userId: Value(userId),
            role: const Value('member'),
            joinedAt: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<void> leaveGroup(String groupId, String userId) async {
    await (_db.delete(_db.groupMembersTable)..where(
          (tbl) => tbl.groupId.equals(groupId) & tbl.userId.equals(userId),
        ))
        .go();
  }

  @override
  Future<List<Group>> getGroupsForPlace(String placeId) async {
    final query = _db.select(_db.groupsTable).join([
      innerJoin(
        _db.groupPlacesTable,
        _db.groupPlacesTable.groupId.equalsExp(_db.groupsTable.id),
      ),
    ]);

    query.where(_db.groupPlacesTable.placeId.equals(placeId));

    final rows = await query.map((row) => row.readTable(_db.groupsTable)).get();

    return rows
        .map(
          (row) => Group(
            id: row.id,
            name: row.name,
            description: row.description,
            createdBy: row.createdBy,
            createdAt: row.createdAt,
            isPublic: row.isPublic,
            requiresApproval: row.requiresApproval,
            autoCheckinEnabled: row.autoCheckinEnabled,
            notificationEnabled: row.notificationEnabled,
          ),
        )
        .toList();
  }

  @override
  Future<List<PlannedVisit>> getPlannedVisitsForPlace(String placeId) async {
    if (_supabaseRepository == null) return [];

    try {
      final visitsData = await _supabaseRepository.fetchPlannedVisitsForPlace(
        placeId,
      );

      return visitsData.map((data) {
        return PlannedVisit(
          id: data['id'],
          placeId: data['place_id'],
          userId: data['user_id'],
          plannedAt: DateTime.parse(data['planned_at']),
          notes: data['notes'] as String?,
          durationMinutes: () {
            final val = data['duration'];
            if (val is int) return val;
            if (val is String) {
              return int.tryParse(val.split(' ')[0]) ?? 60;
            }
            return 60;
          }(),
        );
      }).toList();
    } catch (e) {
      print('Error fetching planned visits for place $placeId: $e');
      return [];
    }
  }

  Future<void> syncGroups(String userId) async {
    if (_supabaseRepository == null) return;

    try {
      final remoteGroups = await _supabaseRepository.fetchMyGroups(userId);

      await _db.transaction(() async {
        for (final group in remoteGroups) {
          // Upsert group
          await _db
              .into(_db.groupsTable)
              .insert(
                GroupsTableCompanion(
                  id: Value(group.id),
                  name: Value(group.name),
                  description: Value(group.description),
                  createdBy: Value(group.createdBy),
                  createdAt: Value(group.createdAt),
                  isPublic: Value(group.isPublic),
                  requiresApproval: Value(group.requiresApproval),
                  autoCheckinEnabled: Value(group.autoCheckinEnabled),
                  notificationEnabled: Value(group.notificationEnabled),
                ),
                mode: InsertMode.insertOrReplace,
              );

          // Get group places
          try {
            final groupPlacesData = await _supabaseRepository.fetchGroupPlaces(
              group.id,
            );

            for (final gpData in groupPlacesData) {
              final placeData = gpData['places'];
              if (placeData != null) {
                // 1. Upsert Place
                await _db
                    .into(_db.placesTable)
                    .insert(
                      PlacesTableCompanion(
                        id: Value(placeData['id']),
                        name: Value(placeData['name']),
                        latitude: Value(placeData['latitude']),
                        longitude: Value(placeData['longitude']),
                        status: Value(placeData['status'] ?? 'active'),
                        description: Value(placeData['description']),
                        address: Value(placeData['address']),
                        createdBy: Value(placeData['created_by']),
                        updatedAt: Value(
                          placeData['updated_at'] != null
                              ? DateTime.parse(placeData['updated_at'])
                              : DateTime.now(), // Fallback to now if null, assuming not nullable in DB
                        ),
                        syncStatus: const Value('synced'),
                      ),
                      mode: InsertMode.insertOrReplace,
                    );

                // 2. Upsert GroupPlace
                await _db
                    .into(_db.groupPlacesTable)
                    .insert(
                      GroupPlacesTableCompanion(
                        groupId: Value(group.id),
                        placeId: Value(placeData['id']),
                        isPrimary: Value(gpData['is_primary'] ?? false),
                        displayOrder: Value(gpData['display_order'] ?? 0),
                        radius: Value(
                          (gpData['radius'] as num?)?.toDouble() ?? 100.0,
                        ),
                        description: Value(gpData['description']),
                        placeType: Value(
                          (gpData['place_type'] as List?)?.join(',') ?? 'other',
                        ),
                      ),
                      mode: InsertMode.insertOrReplace,
                    );
              }
            }
          } catch (e) {
            print('Error syncing places for group ${group.id}: $e');
          }

          // Ensure user is in group_members locally
          // We might want to fetch actual role from Supabase, but for now assume member if not creator
          // Or better, we should fetch group_members too.
          // For this MVP sync, let's just ensure the link exists so getMyGroups works.
          final memberExists =
              await (_db.select(_db.groupMembersTable)..where(
                    (t) => t.groupId.equals(group.id) & t.userId.equals(userId),
                  ))
                  .getSingleOrNull();

          if (memberExists == null) {
            await _db
                .into(_db.groupMembersTable)
                .insert(
                  GroupMembersTableCompanion(
                    groupId: Value(group.id),
                    userId: Value(userId),
                    role: const Value(
                      'member',
                    ), // Defaulting to member for sync
                    joinedAt: Value(DateTime.now()),
                  ),
                );
          }
        }
      });
    } catch (e) {
      print('Error syncing groups: $e');
      // Don't rethrow here, we want to show local data even if sync fails
    }
  }
}
