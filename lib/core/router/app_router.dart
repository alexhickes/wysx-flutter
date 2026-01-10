import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/auth_screen.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/reset_password/reset_password_screen.dart';
import '../../features/auth/presentation/update_password/update_password_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthChangeEvent;
import '../../shared/layout/responsive_shell.dart';
import '../../features/map/presentation/map_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';

import '../presentation/widgets/app_header.dart';

import '../../features/social/presentation/social_screen.dart';
import '../../features/groups/presentation/screens/group_details_screen.dart';
import '../../features/places/presentation/screens/place_details_screen.dart';
import '../../features/account/presentation/account_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    appBar: AppHeader(title: 'Profile'),
    body: Center(child: Text('Profile')),
  );
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final authEvents = ref.watch(authEventsProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authStateProvider.stream),
    ),
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isAuthRoute = state.uri.path == '/auth';
      final isResetRoute =
          state.uri.path == '/reset-password'; // The request page
      final isUpdateRoute =
          state.uri.path == '/auth/reset-password'; // The actual update page

      // Handling password recovery flow
      if (authEvents.value == AuthChangeEvent.passwordRecovery) {
        return '/auth/reset-password';
      }

      if (!isLoggedIn && !isAuthRoute && !isResetRoute && !isUpdateRoute) {
        return '/auth';
      }

      if (isLoggedIn && isAuthRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/auth/reset-password',
        builder: (context, state) => const UpdatePasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ResponsiveShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/map',
                builder: (context, state) => const MapScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/social',
                builder: (context, state) => const SocialScreen(),
                routes: const [],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/places/:id',
        builder: (context, state) {
          final placeId = state.pathParameters['id']!;
          return PlaceDetailsScreen(placeId: placeId);
        },
      ),
      GoRoute(
        path: '/groups/:id',
        builder: (context, state) {
          final groupId = state.pathParameters['id']!;
          return GroupDetailsScreen(groupId: groupId);
        },
      ),
      GoRoute(
        path: '/account',
        builder: (context, state) => const AccountScreen(),
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.listen((dynamic _) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
