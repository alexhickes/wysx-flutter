import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/place.dart';
import '../../../home/presentation/providers/home_providers.dart';
import 'places_provider.dart';

final checkInManagerProvider = Provider<CheckInManager>((ref) {
  return CheckInManager(ref);
});

class CheckInManager {
  final Ref _ref;

  CheckInManager(this._ref) {
    _init();
  }

  void _init() {
    // Listen to location changes
    _ref.listen(currentLocationProvider, (previous, next) {
      next.when(
        data: (location) {
          if (location != null) {
            _checkLocation(location);
          }
        },
        loading: () {},
        error: (_, __) {},
      );
    });

    // Restore state from DB in case we restarted app while checked in
    _restoreState();
  }

  Future<void> _restoreState() async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;

    final repository = _ref.read(placesRepositoryProvider);
    try {
      final activePlaceId = await repository.getActiveCheckIn(user.id);
      if (activePlaceId != null) {
        _lastCheckedInPlaceId = activePlaceId;
        print(
          'CheckInManager: Restored check-in state for place $activePlaceId',
        );
      }
    } catch (e) {
      print('CheckInManager: Failed to restore state: $e');
    }
  }

  Future<void> _checkLocation(LatLng currentLocation) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;

    final placesAsync = _ref.read(allPlacesProvider);
    final places =
        placesAsync.valueOrNull ??
        []; // Best effort, don't wait if not loaded yet

    if (places.isEmpty) return;

    final repository = _ref.read(placesRepositoryProvider);
    const distanceCalculator = Distance();

    // 1. Find place we are currently inside
    Place? insidePlace;
    for (final place in places) {
      final placeLocation = LatLng(place.latitude, place.longitude);
      final distance = distanceCalculator.as(
        LengthUnit.Meter,
        currentLocation,
        placeLocation,
      );

      // Default radius 100m if not specified
      final radius = place.radius ?? 100.0;

      if (distance <= radius) {
        insidePlace = place;
        break; // Assume we can only be in one place at a time for MVP
      }
    }

    // 2. Logic:
    // If insidePlace found:
    //    - Check IN to insidePlace (idempotent usually, or handled by repo)
    //    - Check OUT of all other places (or repo handles implicit checkout)
    // For specific requirement: "Check we are processing check in's correctly"
    // We should call trigger checkIn.

    // WARNING: This listens to location updates, so it fires frequently.
    // We need state to avoid spamming the API.
    // Ideally we should track "currentCheckedInPlaceId".
    // Since we don't have local persistent state for "current checkin" easily accessible synchronously,
    // we make an assumption: rely on the API to be cheap/fast or add a local cache here.
    // Let's add a simple in-memory tracker to avoid repeated calls in the same session.

    if (insidePlace != null) {
      if (_lastCheckedInPlaceId != insidePlace.id) {
        print(
          'CheckInManager: Entering ${insidePlace.name}, triggering CheckIn',
        );
        await repository.checkIn(insidePlace.id, user.id);
        _lastCheckedInPlaceId = insidePlace.id;
        _ref.invalidate(myActiveCheckInsProvider);
      }
    } else {
      // We are not in any place.
      if (_lastCheckedInPlaceId != null) {
        print('CheckInManager: Left place, triggering CheckOutAllActive');
        // Force cleanup of all check-ins to fix any potential multiple check-in issues
        await repository.checkOutAllActive(user.id);
        _lastCheckedInPlaceId = null;
        _ref.invalidate(myActiveCheckInsProvider);
      }
    }
  }

  String? _lastCheckedInPlaceId;
}
