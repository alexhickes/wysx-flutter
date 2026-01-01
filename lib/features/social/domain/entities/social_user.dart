import 'package:equatable/equatable.dart';

class SocialUser extends Equatable {
  final String id;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final bool isSharingLocation;
  final DateTime? checkedInAt;
  final String? locationName;
  final String? placeId;

  factory SocialUser.fromJson(Map<String, dynamic> json) {
    return SocialUser(
      id: json['id'],
      username: json['username'],
      displayName: json['display_name'],
      avatarUrl: json['avatar_url'],
      isSharingLocation: json['is_sharing_location'] ?? false,
      checkedInAt: json['checked_in_at'] != null
          ? DateTime.parse(json['checked_in_at'])
          : null,
      locationName: json['location_name'],
      placeId: json['place_id'],
    );
  }

  const SocialUser({
    required this.id,
    required this.username,
    this.displayName,
    this.avatarUrl,
    this.isSharingLocation = false,
    this.checkedInAt,
    this.locationName,
    this.placeId,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    displayName,
    avatarUrl,
    isSharingLocation,
    checkedInAt,
    locationName,
    placeId,
  ];
}
