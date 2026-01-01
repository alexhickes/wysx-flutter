import 'package:equatable/equatable.dart';

class Activity extends Equatable {
  final String id;
  final String name;
  final String? icon;

  const Activity({required this.id, required this.name, this.icon});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(id: json['id'], name: json['name'], icon: json['icon']);
  }

  @override
  List<Object?> get props => [id, name, icon];
}
