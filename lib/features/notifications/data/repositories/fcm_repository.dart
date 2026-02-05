import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository for managing FCM tokens in Supabase
class FCMRepository {
  final SupabaseClient _supabase;

  FCMRepository(this._supabase);

  /// Save or update FCM token for the current user
  Future<void> saveToken(String token, String platform) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _supabase.from('fcm_tokens').upsert({
        'user_id': userId,
        'token': token,
        'platform': platform,
        'updated_at': DateTime.now().toIso8601String(),
        'last_used_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to save FCM token: $e');
    }
  }

  /// Delete FCM token for the current user
  Future<void> deleteToken(String token) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _supabase
          .from('fcm_tokens')
          .delete()
          .eq('user_id', userId)
          .eq('token', token);
    } catch (e) {
      throw Exception('Failed to delete FCM token: $e');
    }
  }

  /// Delete all FCM tokens for the current user
  Future<void> deleteAllTokens() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _supabase.from('fcm_tokens').delete().eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to delete FCM tokens: $e');
    }
  }

  /// Get all FCM tokens for the current user
  Future<List<Map<String, dynamic>>> getTokens() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await _supabase
          .from('fcm_tokens')
          .select()
          .eq('user_id', userId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to get FCM tokens: $e');
    }
  }

  /// Update last_used_at timestamp for a token
  Future<void> updateLastUsed(String token) async {
    try {
      await _supabase
          .from('fcm_tokens')
          .update({'last_used_at': DateTime.now().toIso8601String()})
          .eq('token', token);
    } catch (e) {
      throw Exception('Failed to update token last_used_at: $e');
    }
  }
}
