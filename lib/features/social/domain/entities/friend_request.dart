import 'package:equatable/equatable.dart';

class FriendRequest extends Equatable {
  final String userId;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final DateTime createdAt;

  const FriendRequest({
    required this.userId,
    required this.username,
    this.displayName,
    this.avatarUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    userId,
    username,
    displayName,
    avatarUrl,
    createdAt,
  ];
}
