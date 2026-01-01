import 'package:equatable/equatable.dart';
import '../../../../features/groups/domain/entities/group.dart';
import '../../../../features/places/domain/entities/place.dart';
import '../../../../features/social/domain/entities/social_user.dart';
import 'activity.dart';

class CheckIn extends Equatable {
  final String id;
  final String userId;
  final String placeId;
  final String? groupId;
  final String? activityId;
  final DateTime checkedInAt;
  final DateTime? checkedOutAt;

  // Joined fields
  final Place? place;
  final SocialUser? user;
  final Activity? activity;
  final Group? group;

  const CheckIn({
    required this.id,
    required this.userId,
    required this.placeId,
    this.groupId,
    this.activityId,
    required this.checkedInAt,
    this.checkedOutAt,
    this.place,
    this.user,
    this.activity,
    this.group,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    placeId,
    groupId,
    activityId,
    checkedInAt,
    checkedOutAt,
    place,
    user,
    activity,
    group,
  ];
}
