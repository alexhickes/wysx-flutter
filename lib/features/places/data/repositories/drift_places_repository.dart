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
    // 1. Get Place IDs first to avoid column ambiguity in join
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

    // Select only the ID to be safe
    final rows = await query
        .map((row) => row.readTable(_db.placesTable).id)
        .get();
    final placeIds = rows.toSet().toList();

    if (placeIds.isEmpty) return [];

    // 2. Fetch Place details in a clean query
    final places = await (_db.select(
      _db.placesTable,
    )..where((tbl) => tbl.id.isIn(placeIds))).get();

    for (final p in places) {
      print('DEBUG: getPlacesForUserGroups fetched: ${p.id} -> ${p.name}');
    }

    return places.map((row) => _mapRowToPlace(row)).toList();
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
    );
  }
}
