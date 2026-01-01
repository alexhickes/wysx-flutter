import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../features/notifications/presentation/providers/notifications_provider.dart';
import '../../../features/notifications/presentation/screens/notifications_screen.dart';

class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  final String title;

  const AppHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: false,
      actions: [
        Consumer(
          builder: (context, ref, child) {
            final count = ref.watch(notificationsCountProvider);
            return IconButton(
              icon: Badge(
                isLabelVisible: count > 0,
                label: Text('$count'),
                child: const Icon(Icons.notifications),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: authState.when(
            data: (user) {
              final avatarUrl = user?.avatarUrl;
              final initial = user?.email.isNotEmpty == true
                  ? user!.email[0].toUpperCase()
                  : '?';

              return PopupMenuButton<String>(
                offset: const Offset(0, 40),
                onSelected: (value) {
                  if (value == 'profile' || value == 'gps') {
                    context.push('/account');
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 20),
                        SizedBox(width: 12),
                        Text('Profile'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'gps',
                    child: Row(
                      children: [
                        Icon(Icons.location_on, size: 20),
                        SizedBox(width: 12),
                        Text('GPS Settings'),
                      ],
                    ),
                  ),
                ],
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: avatarUrl != null
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: avatarUrl == null ? Text(initial) : null,
                ),
              );
            },
            loading: () => const CircleAvatar(
              radius: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (_, __) =>
                const CircleAvatar(radius: 20, child: Icon(Icons.person)),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
