import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'sidebar_navigation.dart';
import '../../core/providers/location_provider.dart';
import '../../features/places/presentation/providers/check_in_manager.dart';

class ResponsiveShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const ResponsiveShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Activate CheckInManager
    ref.watch(checkInManagerProvider);

    final width = MediaQuery.of(context).size.width;

    final permissionStatus = ref.watch(locationPermissionProvider);
    final showWarning =
        permissionStatus == LocationPermissionStatus.denied ||
        permissionStatus == LocationPermissionStatus.deniedForever ||
        permissionStatus == LocationPermissionStatus.disabled;

    final banner = showWarning
        ? Container(
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Location is not being shared',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      ref
                          .read(locationPermissionProvider.notifier)
                          .openSettings();
                    },
                    child: const Text(
                      'Settings',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();

    if (width > 1024) {
      return Scaffold(
        body: Column(
          children: [
            if (showWarning) banner,
            Expanded(
              child: Row(
                children: [
                  SidebarNavigation(
                    selectedIndex: navigationShell.currentIndex,
                    onDestinationSelected: (index) {
                      navigationShell.goBranch(
                        index,
                        initialLocation: index == navigationShell.currentIndex,
                      );
                    },
                  ),
                  Expanded(child: navigationShell),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Column(
          children: [
            if (showWarning) banner,
            Expanded(child: navigationShell),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(Icons.group_outlined),
              selectedIcon: Icon(Icons.group),
              label: 'Social',
            ),
          ],
        ),
      );
    }
  }
}
