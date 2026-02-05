import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/services/notification_service.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/fcm_repository.dart';

/// Provider for the notification service singleton
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Provider for the FCM repository
final fcmRepositoryProvider = Provider<FCMRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return FCMRepository(supabase);
});

/// Provider for the current FCM token
final fcmTokenProvider = FutureProvider<String?>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return service.fcmToken;
});

/// Provider for notification permission status
final notificationPermissionProvider = FutureProvider<AuthorizationStatus>((
  ref,
) async {
  final service = ref.watch(notificationServiceProvider);
  return service.getPermissionStatus();
});

/// Provider to sync FCM token with Supabase
final fcmTokenSyncProvider = FutureProvider<void>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  final repository = ref.watch(fcmRepositoryProvider);
  final user = ref.watch(currentUserProvider);

  if (user == null) {
    return; // User not authenticated
  }

  final token = service.fcmToken;
  if (token == null) {
    return; // No token available
  }

  // Determine platform
  String platform;
  if (Platform.isAndroid) {
    platform = 'android';
  } else if (Platform.isIOS) {
    platform = 'ios';
  } else {
    platform = 'web';
  }

  // Save token to Supabase
  await repository.saveToken(token, platform);
});

/// Provider to handle token refresh
final fcmTokenRefreshListenerProvider = Provider<void>((ref) {
  final service = ref.watch(notificationServiceProvider);
  final repository = ref.watch(fcmRepositoryProvider);

  service.onTokenRefresh = (newToken) async {
    if (newToken == null) return;

    // Determine platform
    String platform;
    if (Platform.isAndroid) {
      platform = 'android';
    } else if (Platform.isIOS) {
      platform = 'ios';
    } else {
      platform = 'web';
    }

    // Save new token to Supabase
    try {
      await repository.saveToken(newToken, platform);
    } catch (e) {
      // Handle error silently
    }
  };
});
