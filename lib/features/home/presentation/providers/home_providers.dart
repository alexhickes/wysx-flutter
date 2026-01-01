import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/supabase_home_repository.dart';
import '../../domain/repositories/i_home_repository.dart';
import '../../domain/entities/check_in.dart';
import '../../../groups/domain/entities/planned_visit.dart';

final homeRepositoryProvider = Provider<IHomeRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseHomeRepository(client);
});

final myActiveCheckInsProvider = FutureProvider.autoDispose<List<CheckIn>>((
  ref,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getMyActiveCheckIns(user.id);
});

final friendsCheckInsProvider = FutureProvider.autoDispose<List<CheckIn>>((
  ref,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getFriendsActiveCheckIns(user.id);
});

final upcomingVisitsProvider = FutureProvider.autoDispose<List<PlannedVisit>>((
  ref,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getUpcomingVisits(user.id);
});

final recentActivityProvider = FutureProvider.autoDispose<List<CheckIn>>((
  ref,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getRecentActivity(user.id);
});
