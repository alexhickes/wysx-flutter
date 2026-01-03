import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/place_with_active_members.dart';
import '../../domain/repositories/i_places_repository.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../groups/presentation/providers/groups_provider.dart';
import '../../../../core/providers/database_provider.dart';
import '../../data/repositories/drift_places_repository.dart';
import '../../data/repositories/supabase_places_repository.dart';

final placesRepositoryProvider = Provider<IPlacesRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final supabaseClient = ref.watch(supabaseClientProvider);
  final supabaseRepository = SupabasePlacesRepository(supabaseClient);

  return DriftPlacesRepository(db, supabaseRepository: supabaseRepository);
});

final myPlacesProvider = FutureProvider<List<PlaceWithActiveMembers>>((
  ref,
) async {
  final repository = ref.watch(placesRepositoryProvider);
  final user = ref.watch(currentUserProvider);

  if (user == null) return [];

  return repository.getMyPlacesWithActiveMembers(user.id);
});

final invitedPlacesProvider = FutureProvider<List<PlaceWithActiveMembers>>((
  ref,
) async {
  final repository = ref.watch(placesRepositoryProvider);
  final user = ref.watch(currentUserProvider);

  if (user == null) return [];

  // Ensure groups (and thus group places) are synced before fetching
  // We can do this by watching the groups provider or directly calling sync if we had access.
  // Using the provider is cleaner as it manages the sync state.
  // We don't need the result, just the side effect of sync completion.
  try {
    // Import this: import '../../../groups/presentation/providers/groups_provider.dart';
    await ref.watch(myGroupsProvider.future);
  } catch (e) {
    print('Error ensuring groups are synced: $e');
    // Continue even if sync fails, we might have local data
  }

  return repository.getGroupPlacesWithActiveMembers(user.id);
});

final allPlacesProvider = FutureProvider<List<Place>>((ref) async {
  final myPlaces = await ref.watch(myPlacesProvider.future);
  final groupPlaces = await ref.watch(invitedPlacesProvider.future);

  // Combine and remove duplicates based on ID
  final Map<String, Place> uniquePlaces = {};
  for (final pm in myPlaces) {
    uniquePlaces[pm.place.id] = pm.place;
  }
  for (final pm in groupPlaces) {
    uniquePlaces[pm.place.id] = pm.place;
  }

  return uniquePlaces.values.toList();
});

final allPlacesWithActiveMembersProvider =
    FutureProvider<List<PlaceWithActiveMembers>>((ref) async {
      final repository = ref.watch(placesRepositoryProvider);
      final user = ref.watch(currentUserProvider);

      if (user == null) return [];

      return repository.getPlacesWithActiveMembers(user.id);
    });

final placeDetailsProvider = FutureProvider.family<Place?, String>((
  ref,
  placeId,
) async {
  final places = await ref.watch(allPlacesProvider.future);
  try {
    return places.firstWhere((p) => p.id == placeId);
  } catch (_) {
    return null;
  }
});

final placeWithActiveMembersProvider =
    FutureProvider.family<PlaceWithActiveMembers?, String>((
      ref,
      placeId,
    ) async {
      final repository = ref.watch(placesRepositoryProvider);
      return repository.getPlaceWithActiveMembers(placeId);
    });

final currentLocationProvider = FutureProvider<LatLng?>((ref) async {
  try {
    // Check permission first (though MapScreen handles this usually)
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    final position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  } catch (e) {
    return null;
  }
});

final nearbyPlacesProvider = FutureProvider<List<Place>>((ref) async {
  // For now, just return all places.
  // In a real app, we might filter by distance from currentLocationProvider
  return ref.watch(allPlacesProvider.future);
});
