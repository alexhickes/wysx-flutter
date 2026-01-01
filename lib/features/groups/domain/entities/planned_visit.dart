import 'package:equatable/equatable.dart';

class PlannedVisit extends Equatable {
  final String id;
  final String placeId;
  final String userId;
  final DateTime plannedAt;
  final String? notes;
  final int durationMinutes;

  const PlannedVisit({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.plannedAt,
    this.notes,
    required this.durationMinutes,
  });

  @override
  List<Object?> get props => [
    id,
    placeId,
    userId,
    plannedAt,
    notes,
    durationMinutes,
  ];
}
