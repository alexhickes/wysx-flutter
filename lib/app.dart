import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/location_provider.dart';

import 'features/settings/presentation/providers/settings_providers.dart';

class WysxApp extends ConsumerWidget {
  const WysxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
