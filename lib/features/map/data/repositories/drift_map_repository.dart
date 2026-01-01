import 'package:drift/drift.dart';
import '../../../../core/services/app_database.dart';
import '../../../places/domain/entities/place.dart';
import '../../domain/repositories/i_map_repository.dart';

class DriftMapRepository implements IMapRepository {
  final AppDatabase _db;

  DriftMapRepository(this._db);

  @override
  Future<List<Place>> getPlaces() async {
    final query = _db.select(_db.placesTable).join([
      leftOuterJoin(
        _db.groupPlacesTable,
        _db.groupPlacesTable.placeId.equalsExp(_db.placesTable.id),
      ),
    ]);

    final rows = await query.get();

    // Group by place ID to handle duplicates (one place in multiple groups)
    final Map<String, Place> uniquePlaces = {};

    for (final row in rows) {
      final placeRow = row.readTable(_db.placesTable);
      final groupPlaceRow = row.readTableOrNull(_db.groupPlacesTable);

      final currentPlace = uniquePlaces[placeRow.id];
      final newRadius = groupPlaceRow?.radius;

      if (currentPlace == null) {
        uniquePlaces[placeRow.id] = _mapRowToPlace(placeRow, radius: newRadius);
      } else {
        // If place already exists, keep the larger radius
        if (newRadius != null &&
            (currentPlace.radius == null || newRadius > currentPlace.radius!)) {
          uniquePlaces[placeRow.id] = _mapRowToPlace(
            placeRow,
            radius: newRadius,
          );
        }
      }
    }

    return uniquePlaces.values.toList();
  }

  @override
  Future<void> addPlace(Place place) async {
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
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<List<Place>> searchPlaces(String query) async {
    final rows = await (_db.select(
      _db.placesTable,
    )..where((tbl) => tbl.name.contains(query))).get();
    return rows.map((row) => _mapRowToPlace(row)).toList();
  }

  Place _mapRowToPlace(PlacesTableData row, {double? radius}) {
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
      updatedAt: row.updatedAt,
      radius: radius,
    );
  }
}
