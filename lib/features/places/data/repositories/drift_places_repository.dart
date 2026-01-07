import 'package:drift/drift.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/services/app_database.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/place_with_active_members.dart';
import '../../domain/repositories/i_places_repository.dart';
import 'supabase_places_repository.dart';

class DriftPlacesRepository implements IPlacesRepository {
  final AppDatabase _db;
  final SupabasePlacesRepository? _supabaseRepository;

  DriftPlacesRepository(
    this._db, {
    SupabasePlacesRepository? supabaseRepository,
  }) : _supabaseRepository = supabaseRepository;

  @override
  Future<List<Place>> getNearbyPlaces(
    double latitude,
    double longitude, {
    double maxDistance = 5000,
  }) async {
    // Fetch all places and filter in memory for now (SQLite doesn't support complex math easily)
    // Optimization: Filter by bounding box first if performance becomes an issue
    final rows = await _db.select(_db.placesTable).get();
    final center = LatLng(latitude, longitude);
    const distance = Distance();

    final nearbyRows = rows.where((row) {
      final placeLoc = LatLng(row.latitude, row.longitude);
      return distance.as(LengthUnit.Meter, center, placeLoc) <= maxDistance;
    });

    return nearbyRows.map((row) => _mapRowToPlace(row)).toList();
  }

  @override
  Future<Place?> getPlace(String placeId) async {
    final row = await (_db.select(
      _db.placesTable,
    )..where((tbl) => tbl.id.equals(placeId))).getSingleOrNull();

    if (row == null) return null;
    return _mapRowToPlace(row);
  }

  @override
  Future<void> createPlace(Place place) async {
    // 1. Insert locally with 'created' status
    await _db
        .into(_db.placesTable)
        .insert(
          PlacesTableCompanion(
            id: Value(place.id),
            name: Value(place.name),
            latitude: Value(place.latitude),
            longitude: Value(place.longitude),
            status: Value(place.status.name),
            description: Value(place.description),
            address: Value(place.address),
            createdBy: Value(place.createdBy),
            updatedAt: Value(place.updatedAt),
            syncStatus: const Value('created'),
            radius: Value(place.radius),
          ),
          mode: InsertMode.insertOrReplace,
        );

    // 2. Try to sync to Supabase
    if (_supabaseRepository != null) {
      try {
        await _supabaseRepository.createPlace(place);

        // 3. Update local status to 'synced' on success
        await (_db.update(_db.placesTable)
              ..where((tbl) => tbl.id.equals(place.id)))
            .write(const PlacesTableCompanion(syncStatus: Value('synced')));
      } catch (e) {
        // Ignore error, will sync later via background job (to be implemented)
        print('Error syncing place to Supabase: $e');
        rethrow; // Rethrow to surface error to UI for debugging
      }
    }
  }

  @override
  Future<void> updatePlace(Place place) async {
    await (_db.update(
      _db.placesTable,
    )..where((tbl) => tbl.id.equals(place.id))).write(
      PlacesTableCompanion(
        name: Value(place.name),
        latitude: Value(place.latitude),
        longitude: Value(place.longitude),
        status: Value(place.status.name),
        description: Value(place.description),
        address: Value(place.address),
        updatedAt: Value(place.updatedAt),
        syncStatus: const Value('updated'),
        radius: Value(place.radius),
      ),
    );

    // TODO: Implement update sync
  }

  @override
  Future<void> deletePlace(String placeId) async {
    await (_db.delete(
      _db.placesTable,
    )..where((tbl) => tbl.id.equals(placeId))).go();

    // TODO: Implement delete sync
  }

  @override
  Future<List<Place>> getPlacesForUserGroups(String userId) async {
    // Join places, group_places, groups, group_members
    final query = _db.select(_db.placesTable).join([
      innerJoin(
        _db.groupPlacesTable,
        _db.groupPlacesTable.placeId.equalsExp(_db.placesTable.id),
      ),
      innerJoin(
        _db.groupsTable,
        _db.groupsTable.id.equalsExp(_db.groupPlacesTable.groupId),
      ),
      innerJoin(
        _db.groupMembersTable,
        _db.groupMembersTable.groupId.equalsExp(_db.groupsTable.id),
      ),
    ]);

    query.where(_db.groupMembersTable.userId.equals(userId));

    final rows = await query.get();

    // Group results by Place ID to find max radius per place
    final Map<String, Place> placesMap = {};
    final Map<String, double> maxRadiusMap = {};

    for (final row in rows) {
      final placeData = row.readTable(_db.placesTable);
      final groupPlaceData = row.readTable(_db.groupPlacesTable);

      // Store base place data if not already present
      if (!placesMap.containsKey(placeData.id)) {
        placesMap[placeData.id] = _mapRowToPlace(placeData);
      }

      // Calculate max radius: use group_places radius
      // Note: radius in GroupPlacesTable is non-nullable with default 100.0
      final radius = groupPlaceData.radius;
      final currentMax = maxRadiusMap[placeData.id] ?? 0.0;
      if (radius > currentMax) {
        maxRadiusMap[placeData.id] = radius;
      }
    }

    // Return places with the correctly assigned max radius
    return placesMap.values.map((place) {
      final maxRadius = maxRadiusMap[place.id];
      // If we found a group radius, use it. Otherwise fall back to place's own radius.
      return place.copyWith(radius: maxRadius ?? place.radius);
    }).toList();
  }

  @override
  Future<List<Place>> getMyPlaces(String userId) async {
    final rows = await (_db.select(
      _db.placesTable,
    )..where((tbl) => tbl.createdBy.equals(userId))).get();
    return rows.map((row) => _mapRowToPlace(row)).toList();
  }

  @override
  Future<List<PlaceWithActiveMembers>> getMyPlacesWithActiveMembers(
    String userId,
  ) async {
    final places = await getMyPlaces(userId);
    return _attachActiveMembers(places);
  }

  @override
  Future<List<PlaceWithActiveMembers>> getGroupPlacesWithActiveMembers(
    String userId,
  ) async {
    final places = await getPlacesForUserGroups(userId);
    return _attachActiveMembers(places);
  }

  Future<List<PlaceWithActiveMembers>> _attachActiveMembers(
    List<Place> places,
  ) async {
    if (places.isEmpty) return [];

    if (_supabaseRepository == null) {
      return places
          .map(
            (place) =>
                PlaceWithActiveMembers(place: place, activeMembers: const []),
          )
          .toList();
    }

    try {
      final placeIds = places.map((p) => p.id).toList();
      print('DEBUG: Fetching active members for places: $placeIds');

      final activeMembersMap = await _supabaseRepository
          .fetchActiveMembersAtPlaces(placeIds);

      print(
        'DEBUG: Active members fetched: ${activeMembersMap.length} places with activity',
      );
      activeMembersMap.forEach((k, v) {
        print('DEBUG: Place $k has ${v.length} active members');
      });

      return places.map((place) {
        final activeMembers = activeMembersMap[place.id] ?? [];
        return PlaceWithActiveMembers(
          place: place,
          activeMembers: activeMembers,
        );
      }).toList();
    } catch (e) {
      print('Error fetching active members: $e');
      return places
          .map(
            (place) =>
                PlaceWithActiveMembers(place: place, activeMembers: const []),
          )
          .toList();
    }
  }

  @override
  Future<List<PlaceWithActiveMembers>> getPlacesWithActiveMembers(
    String userId,
  ) async {
    // Get all places (my places + group places)
    final myPlaces = await getMyPlaces(userId);
    final groupPlaces = await getPlacesForUserGroups(userId);

    // Combine and deduplicate
    final Map<String, Place> uniquePlaces = {};
    for (final place in myPlaces) {
      uniquePlaces[place.id] = place;
    }
    for (final place in groupPlaces) {
      uniquePlaces[place.id] = place;
    }

    return _attachActiveMembers(uniquePlaces.values.toList());
  }

  @override
  Future<PlaceWithActiveMembers?> getPlaceWithActiveMembers(
    String placeId,
  ) async {
    final place = await getPlace(placeId);
    if (place == null) return null;

    if (_supabaseRepository == null) {
      return PlaceWithActiveMembers(place: place, activeMembers: const []);
    }

    try {
      print('DEBUG: Fetching active members for single place: $placeId');
      final activeMembersMap = await _supabaseRepository
          .fetchActiveMembersAtPlaces([placeId]);

      final activeMembers = activeMembersMap[placeId] ?? [];
      print(
        'DEBUG: Single place fetch result: ${activeMembers.length} active members',
      );

      return PlaceWithActiveMembers(place: place, activeMembers: activeMembers);
    } catch (e) {
      print('Error fetching active members for place $placeId: $e');
      return PlaceWithActiveMembers(place: place, activeMembers: const []);
    }
  }

  Place _mapRowToPlace(PlacesTableData row) {
    return Place(
      id: row.id,
      name: row.name,
      latitude: row.latitude,
      longitude: row.longitude,
      status: PlaceStatus.values.firstWhere(
        (e) => e.name == row.status,
        orElse: () => PlaceStatus.inactive,
      ),
      description: row.description,
      address: row.address,
      createdBy: row.createdBy,
      updatedAt: row.updatedAt,
      syncStatus: row.syncStatus,
      radius: row.radius,
    );
  }

  @override
  Future<void> checkIn(String placeId, String userId) async {
    // Only support online check-in for now
    if (_supabaseRepository != null) {
      await _supabaseRepository.checkIn(placeId, userId);
    }
  }

  @override
  Future<void> checkOut(String placeId, String userId) async {
    // Only support online check-out for now
    if (_supabaseRepository != null) {
      await _supabaseRepository.checkOut(placeId, userId);
    }
  }
}
