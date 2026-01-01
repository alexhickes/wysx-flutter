import '../entities/place.dart';
import '../entities/place_with_active_members.dart';

abstract class IPlacesRepository {
  Future<List<Place>> getNearbyPlaces(
    double latitude,
    double longitude, {
    double maxDistance = 5000,
  });
  Future<Place?> getPlace(String placeId);
  Future<void> createPlace(Place place);
  Future<void> updatePlace(Place place);
  Future<void> deletePlace(String placeId);
  Future<List<Place>> getPlacesForUserGroups(String userId);
  Future<List<Place>> getMyPlaces(String userId);
  Future<List<PlaceWithActiveMembers>> getPlacesWithActiveMembers(
    String userId,
  );
  Future<List<PlaceWithActiveMembers>> getMyPlacesWithActiveMembers(
    String userId,
  );
  Future<List<PlaceWithActiveMembers>> getGroupPlacesWithActiveMembers(
    String userId,
  );
  Future<PlaceWithActiveMembers?> getPlaceWithActiveMembers(String placeId);
}
