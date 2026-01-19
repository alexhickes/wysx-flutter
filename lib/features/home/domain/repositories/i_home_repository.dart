import '../../../groups/domain/entities/planned_visit.dart';
import '../entities/check_in.dart';

abstract class IHomeRepository {
  Future<List<CheckIn>> getMyActiveCheckIns(String userId);
  Stream<List<CheckIn>> getMyActiveCheckInsStream(String userId);
  Future<List<CheckIn>> getFriendsActiveCheckIns(String userId);
  Stream<List<CheckIn>> getFriendsActiveCheckInsStream(String userId);
  Future<List<PlannedVisit>> getUpcomingVisits(String userId);
  Future<List<CheckIn>> getRecentActivity(String userId);
}
