import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/database_provider.dart';
import '../../data/repositories/drift_groups_repository.dart';
import '../../data/repositories/supabase_groups_repository.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/group_with_stats.dart';
import '../../domain/entities/planned_visit.dart';
import '../../domain/repositories/i_groups_repository.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

final groupsRepositoryProvider = Provider<IGroupsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final supabaseClient = ref.watch(supabaseClientProvider);
  final supabaseRepository = SupabaseGroupsRepository(supabaseClient);

  return DriftGroupsRepository(db, supabaseRepository: supabaseRepository);
});

final myGroupsProvider = FutureProvider<List<Group>>((ref) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) return [];

  final repository = ref.watch(groupsRepositoryProvider);

  // Trigger sync in background or await it?
  // Awaiting it ensures fresh data but might be slow.
  // Given the user complaint, let's await it for now.
  if (repository is DriftGroupsRepository) {
    await repository.syncGroups(currentUser.id);
  }

  return repository.getMyGroups(currentUser.id);
});

final myGroupsWithStatsProvider = FutureProvider<List<GroupWithStats>>((
  ref,
) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) return [];

  final repository = ref.watch(groupsRepositoryProvider);

  // Sync groups first
  if (repository is DriftGroupsRepository) {
    await repository.syncGroups(currentUser.id);
  }

  return repository.getMyGroupsWithStats(currentUser.id);
});

final myPendingGroupInvitationsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
      final currentUser = ref.watch(currentUserProvider);
      if (currentUser == null) return [];

      final client = ref.watch(supabaseClientProvider);
      final repository = SupabaseGroupsRepository(client);

      return repository.fetchMyPendingInvitations(currentUser.id);
    });

final groupDetailsProvider = FutureProvider.family<Group, String>((
  ref,
  groupId,
) async {
  final client = ref.watch(supabaseClientProvider);
  final repository = SupabaseGroupsRepository(client);
  return repository.fetchGroupDetails(groupId);
});

final groupMembersProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      groupId,
    ) async {
      final client = ref.watch(supabaseClientProvider);
      final repository = SupabaseGroupsRepository(client);
      return repository.fetchGroupMembers(groupId);
    });

final groupPlacesProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      groupId,
    ) async {
      final client = ref.watch(supabaseClientProvider);
      final repository = SupabaseGroupsRepository(client);
      return repository.fetchGroupPlaces(groupId);
    });

final groupPlannedVisitsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((
      ref,
      groupId,
    ) async {
      final client = ref.watch(supabaseClientProvider);
      final repository = SupabaseGroupsRepository(client);
      return repository.fetchPlannedVisits(groupId);
    });

final groupsForPlaceProvider = FutureProvider.family<List<Group>, String>((
  ref,
  placeId,
) async {
  final repository = ref.watch(groupsRepositoryProvider);
  return repository.getGroupsForPlace(placeId);
});

final plannedVisitsForPlaceProvider =
    FutureProvider.family<List<PlannedVisit>, String>((ref, placeId) async {
      final repository = ref.watch(groupsRepositoryProvider);
      return repository.getPlannedVisitsForPlace(placeId);
    });
