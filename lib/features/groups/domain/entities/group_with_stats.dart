import 'package:equatable/equatable.dart';
import 'group.dart';

/// Extended group entity that includes statistics about active members and places
class GroupWithStats extends Equatable {
  final Group group;
  final int activeFriendsCount;
  final int activePlacesCount;

  const GroupWithStats({
    required this.group,
    required this.activeFriendsCount,
    required this.activePlacesCount,
  });

  /// Returns a formatted description like "3 friend(s) are at 2 place(s)"
  String get activityDescription {
    if (activeFriendsCount == 0) {
      return 'No friends currently checked in';
    }

    final friendText = activeFriendsCount == 1 ? 'friend' : 'friends';
    final placeText = activePlacesCount == 1 ? 'place' : 'places';

    return '$activeFriendsCount $friendText at $activePlacesCount $placeText';
  }

  @override
  List<Object?> get props => [group, activeFriendsCount, activePlacesCount];
}
