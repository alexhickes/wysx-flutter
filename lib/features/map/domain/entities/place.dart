import 'package:equatable/equatable.dart';

enum PlaceStatus {
  active, // Purple (Friends checked in)
  planned, // Orange (Planned visits)
  inactive, // Grey (No activity)
}

class Place extends Equatable {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final PlaceStatus status;
  final String? description;

  const Place({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.status = PlaceStatus.inactive,
    this.description,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    latitude,
    longitude,
    status,
    description,
  ];
}
