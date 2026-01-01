import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String createdBy;
  final DateTime createdAt;
  final bool isPublic;
  final bool requiresApproval;
  final bool autoCheckinEnabled;
  final bool notificationEnabled;

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      isPublic: json['is_public'] ?? false,
      requiresApproval: json['requires_approval'] ?? false,
      autoCheckinEnabled: json['auto_checkin_enabled'] ?? false,
      notificationEnabled: json['notification_enabled'] ?? true,
    );
  }

  const Group({
    required this.id,
    required this.name,
    this.description,
    required this.createdBy,
    required this.createdAt,
    this.isPublic = false,
    this.requiresApproval = false,
    this.autoCheckinEnabled = false,
    this.notificationEnabled = true,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    createdBy,
    createdAt,
    isPublic,
    requiresApproval,
    autoCheckinEnabled,
    notificationEnabled,
  ];
}
