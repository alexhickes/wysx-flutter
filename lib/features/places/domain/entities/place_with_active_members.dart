import 'package:equatable/equatable.dart';
import 'place.dart';

/// Represents a group member who is currently checked in at a place
class ActiveMember extends Equatable {
  final String id;
  final String username;
  final String? displayName;

  final String? avatarUrl;
  final DateTime? checkedInAt;

  const ActiveMember({
    required this.id,
    required this.username,
    this.displayName,
    this.avatarUrl,
    this.checkedInAt,
  });

  /// Returns the display name or username
  String get name => displayName ?? username;

  /// Returns the first letter for avatar display
  String get initial => (displayName ?? username).substring(0, 1).toUpperCase();

  @override
  List<Object?> get props => [
    id,
    username,
    displayName,
    avatarUrl,
    checkedInAt,
  ];
}

/// Extended place entity that includes active members currently at the location
class PlaceWithActiveMembers extends Equatable {
  final Place place;
  final List<ActiveMember> activeMembers;
  final int upcomingVisitCount;

  const PlaceWithActiveMembers({
    required this.place,
    required this.activeMembers,
    this.upcomingVisitCount = 0,
  });

  /// Returns the count of active members
  int get activeMembersCount => activeMembers.length;

  /// Returns a formatted description like "3 members here"
  String get activityDescription {
    if (activeMembers.isEmpty) {
      return 'No members here';
    }

    if (activeMembers.length == 1) {
      return '${activeMembers.first.name} is here';
    }

    return '$activeMembersCount members here';
  }

  /// Returns a formatted description like "3 visits planned"
  String get upcomingVisitsDescription {
    if (upcomingVisitCount == 0) return '';
    if (upcomingVisitCount == 1) return '1 visit planned';
    return '$upcomingVisitCount visits planned';
  }

  @override
  List<Object?> get props => [place, activeMembers, upcomingVisitCount];
}
