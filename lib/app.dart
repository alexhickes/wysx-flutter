import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/location_provider.dart';

import 'features/settings/presentation/providers/settings_providers.dart';
import 'features/places/presentation/providers/check_in_manager.dart';
import 'features/notifications/presentation/providers/fcm_providers.dart';
import 'features/notifications/presentation/handlers/notification_handler.dart';

class WysxApp extends ConsumerStatefulWidget {
  const WysxApp({super.key});

  @override
  ConsumerState<WysxApp> createState() => _WysxAppState();
}

class _WysxAppState extends ConsumerState<WysxApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    _setupNotificationHandlers();
  }

  void _setupNotificationHandlers() {
    final notificationService = ref.read(notificationServiceProvider);

    // Set up notification tap handlers
    notificationService.onMessageReceived = (message) {
      debugPrint('📨 Foreground notification received in app');
    };

    notificationService.onMessageOpenedApp = (message) {
      debugPrint('📬 Notification opened app');
      final handler = ref.read(notificationHandlerProvider);
      handler.handleNotificationTap(message);
    };
  }

  @override
  Widget build(BuildContext context) {
    // Initialize CheckInManager globally to monitor location changes
    ref.watch(checkInManagerProvider);

    // Sync FCM token with Supabase when user is authenticated
    ref.watch(fcmTokenSyncProvider);

    // Set up token refresh listener
    ref.watch(fcmTokenRefreshListenerProvider);

    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    // Trigger location permission check/request on app start
    ref.listen(locationPermissionProvider, (previous, next) {
      // Listener just to keep it alive/active if needed,
      // but simpler is to just read/check it.
    });
    // Or better, use a StateFul widget or just call it:
    // We want to request if undetermined.
    final locationStatus = ref.watch(locationPermissionProvider);
    if (locationStatus == LocationPermissionStatus.undetermined) {
      // Defer slightly to allow first frame?
      // Actually provider constructor calls checkPermission(),
      // but we want to REQUEST if not determined.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(locationPermissionProvider.notifier).requestPermission();
      });
    }

    return MaterialApp.router(
      title: 'WysX',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
