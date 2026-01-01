import 'package:equatable/equatable.dart';

enum PlaceStatus { active, planned, inactive }

class Place extends Equatable {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final PlaceStatus status;
  final String? description;
  final String? address;

  final String? createdBy;
  final DateTime updatedAt;
  final String syncStatus;
  final double? radius;
  final String? placeType;
  final bool isPublic;

  const Place({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.status = PlaceStatus.inactive,
    this.description,
    this.address,
    this.createdBy,
    required this.updatedAt,
    this.syncStatus = 'synced',
    this.radius,
    this.placeType,
    this.isPublic = false,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: PlaceStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PlaceStatus.inactive,
      ),
      description: json['description'],
      address: json['address'],
      createdBy: json['created_by'],
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      syncStatus: json['sync_status'] ?? 'synced',
      radius: json['radius'] != null
          ? (json['radius'] as num).toDouble()
          : null,
      placeType: json['place_type'],
      isPublic: json['is_public'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    latitude,
    longitude,
    status,
    description,
    address,
    createdBy,
    updatedAt,
    syncStatus,
    radius,
    placeType,
    isPublic,
  ];
}
