import '../../../places/domain/entities/place.dart';

abstract class IMapRepository {
  Future<List<Place>> getPlaces();
  Future<void> addPlace(Place place);
  Future<List<Place>> searchPlaces(String query);
}
