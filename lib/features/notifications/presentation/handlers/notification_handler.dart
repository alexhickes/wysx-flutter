import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/router/app_router.dart';

/// Handler for notification routing and actions
class NotificationHandler {
  final Ref ref;

  NotificationHandler(this.ref);

  /// Handle notification tap/open
  void handleNotificationTap(RemoteMessage message) {
    debugPrint('🔔 Handling notification tap: ${message.data}');

    final data = message.data;
    final type = data['type'] as String?;

    if (type == null) {
      debugPrint('⚠️ Notification has no type, ignoring');
      return;
    }

    // Route based on notification type
    switch (type) {
      case 'friend_request':
        _navigateToNotifications();
        break;

      case 'friend_request_accepted':
        final userId = data['user_id'] as String?;
        if (userId != null) {
          _navigateToUserProfile(userId);
        }
        break;

      case 'group_invitation':
        final groupId = data['group_id'] as String?;
        if (groupId != null) {
          _navigateToGroupDetails(groupId);
        } else {
          _navigateToNotifications();
        }
        break;

      case 'check_in':
        final placeId = data['place_id'] as String?;
        if (placeId != null) {
          _navigateToPlaceDetails(placeId);
        }
        break;

      case 'planned_visit':
        final groupId = data['group_id'] as String?;
        final placeId = data['place_id'] as String?;
        if (groupId != null) {
          _navigateToGroupDetails(groupId);
        } else if (placeId != null) {
          _navigateToPlaceDetails(placeId);
        }
        break;

      default:
        debugPrint('⚠️ Unknown notification type: $type');
        _navigateToNotifications();
    }
  }

  void _navigateToNotifications() {
    debugPrint('📍 Navigating to notifications screen');
    ref.read(goRouterProvider).go('/notifications');
  }

  void _navigateToUserProfile(String userId) {
    debugPrint('📍 Navigating to user profile: $userId');
    // TODO: Implement user profile navigation
    // ref.read(goRouterProvider).go('/profile/$userId');
    _navigateToNotifications(); // Fallback for now
  }

  void _navigateToGroupDetails(String groupId) {
    debugPrint('📍 Navigating to group details: $groupId');
    ref.read(goRouterProvider).go('/groups/$groupId');
  }

  void _navigateToPlaceDetails(String placeId) {
    debugPrint('📍 Navigating to place details: $placeId');
    ref.read(goRouterProvider).go('/places/$placeId');
  }
}

/// Provider for notification handler
final notificationHandlerProvider = Provider<NotificationHandler>((ref) {
  return NotificationHandler(ref);
});
