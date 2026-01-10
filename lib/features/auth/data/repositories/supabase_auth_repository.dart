import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/i_auth_repository.dart';

class SupabaseAuthRepository implements IAuthRepository {
  final supabase.SupabaseClient _client;

  SupabaseAuthRepository(this._client);

  @override
  Stream<AuthUser?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((event) {
      final session = event.session;
      if (session == null) return null;
      return _mapUser(session.user);
    });
  }

  @override
  Future<AuthUser?> get currentUser async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return _mapUser(user);
  }

  AuthUser _mapUser(supabase.User user) {
    return AuthUser(
      id: user.id,
      email: user.email ?? '',
      username: user.userMetadata?['username'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
    );
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    String username,
  ) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
  }

  @override
  Future<void> signInWithMagicLink(String email) async {
    await _client.auth.signInWithOtp(
      email: email,
      emailRedirectTo: 'io.supabase.wysx://login-callback/',
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(supabase.OAuthProvider.google);
  }

  @override
  Future<void> signInWithFacebook() async {
    await _client.auth.signInWithOAuth(supabase.OAuthProvider.facebook);
  }

  @override
  Future<void> signInWithApple() async {
    await _client.auth.signInWithOAuth(supabase.OAuthProvider.apple);
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Stream<supabase.AuthChangeEvent> get authEvents =>
      _client.auth.onAuthStateChange.map((event) => event.event);

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    final redirectTo = kIsWeb
        ? 'https://wysx-flutter.vercel.app/auth/reset-password'
        : 'io.supabase.wysx://auth/reset-password';

    await _client.auth.resetPasswordForEmail(email, redirectTo: redirectTo);
  }

  @override
  Future<void> updatePassword(String password) async {
    await _client.auth.updateUser(supabase.UserAttributes(password: password));
  }
}
