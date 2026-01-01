import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? username;
  final String? avatarUrl;

  const AuthUser({
    required this.id,
    required this.email,
    this.username,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, email, username, avatarUrl];
}
