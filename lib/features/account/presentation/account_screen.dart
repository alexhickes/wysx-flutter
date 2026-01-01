import 'package:app_settings/app_settings.dart' as sys_settings;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../../settings/domain/entities/app_settings.dart';
import '../../settings/presentation/providers/settings_providers.dart';

import '../../../core/presentation/widgets/app_header.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: const AppHeader(title: 'Account'),
      body: CustomScrollView(
        slivers: [
          // SliverAppBar.large(title: const Text('Account')), // Removed in favor of AppHeader
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (user != null) ...[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      child: Text(
                        user.email.substring(0, 1).toUpperCase(),
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ),
          settingsAsync.when(
            data: (settings) => SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader(context, 'Appearance'),
                _buildThemeOption(context, ref, settings),
                const Divider(),
                _buildSectionHeader(context, 'GPS Settings'),
                _buildGpsToggle(context, ref, settings),
                _buildPerformanceMode(context, ref, settings),
                const Divider(),
                _buildSectionHeader(context, 'Privacy & Sharing'),
                _buildGhostMode(context, ref, settings),
                const Divider(),
                _buildSectionHeader(context, 'System'),
                ListTile(
                  leading: const Icon(Icons.settings_applications),
                  title: const Text('App Settings'),
                  subtitle: const Text('Permissions & Storage'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => sys_settings.AppSettings.openAppSettings(),
                ),
                ListTile(
                  leading: const Icon(Icons.battery_std),
                  title: const Text('Battery Optimization'),
                  subtitle: const Text('Manage battery usage'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => sys_settings.AppSettings.openAppSettings(
                    type: sys_settings.AppSettingsType.batteryOptimization,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: const Text('Location Settings'),
                  subtitle: const Text('System location preferences'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => sys_settings.AppSettings.openAppSettings(
                    type: sys_settings.AppSettingsType.location,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    ref.read(authRepositoryProvider).signOut();
                  },
                ),
                const SizedBox(height: 50),
              ]),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) =>
                SliverFillRemaining(child: Center(child: Text('Error: $err'))),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    return ListTile(
      leading: const Icon(Icons.brightness_6),
      title: const Text('Theme'),
      subtitle: Text(settings.themeMode.name.toUpperCase()),
      trailing: DropdownButton<ThemeModePreference>(
        value: settings.themeMode,
        underline: const SizedBox(),
        items: ThemeModePreference.values.map((mode) {
          return DropdownMenuItem(
            value: mode,
            child: Text(mode.name.toUpperCase()),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            ref.read(settingsRepositoryProvider).updateThemeMode(value);
          }
        },
      ),
    );
  }

  Widget _buildGpsToggle(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    return SwitchListTile(
      secondary: const Icon(Icons.location_on),
      title: const Text('Location Services'),
      subtitle: const Text('Allow app to access location'),
      value: settings.gpsEnabled,
      onChanged: (value) {
        ref.read(settingsRepositoryProvider).updateGpsEnabled(value);
      },
    );
  }

  Widget _buildPerformanceMode(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    return ListTile(
      leading: const Icon(Icons.speed),
      title: const Text('Performance Mode'),
      subtitle: Text(settings.gpsPerformanceMode.name.toUpperCase()),
      enabled: settings.gpsEnabled,
      trailing: PopupMenuButton<GpsPerformanceMode>(
        onSelected: (value) {
          ref.read(settingsRepositoryProvider).updateGpsPerformanceMode(value);
        },
        itemBuilder: (context) => GpsPerformanceMode.values.map((mode) {
          return PopupMenuItem(
            value: mode,
            child: Text(mode.name.toUpperCase()),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGhostMode(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    final isGhost =
        settings.ghostModeUntil != null &&
        settings.ghostModeUntil!.isAfter(DateTime.now());

    return ListTile(
      leading: Icon(
        Icons.visibility_off,
        color: isGhost ? Colors.purple : null,
      ),
      title: const Text('Ghost Mode'),
      subtitle: isGhost
          ? Text(
              'Active until ${settings.ghostModeUntil?.hour}:${settings.ghostModeUntil?.minute}',
            )
          : const Text('Pause location sharing'),
      trailing: Switch(
        value: isGhost,
        onChanged: (value) {
          if (value) {
            _showGhostModeDialog(context, ref);
          } else {
            ref.read(settingsRepositoryProvider).setGhostMode(null);
          }
        },
      ),
    );
  }

  Future<void> _showGhostModeDialog(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Pause Location for...'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                ref
                    .read(settingsRepositoryProvider)
                    .setGhostMode(const Duration(minutes: 30));
                context.pop();
              },
              child: const Text('30 Minutes'),
            ),
            SimpleDialogOption(
              onPressed: () {
                ref
                    .read(settingsRepositoryProvider)
                    .setGhostMode(const Duration(hours: 1));
                context.pop();
              },
              child: const Text('1 Hour'),
            ),
            SimpleDialogOption(
              onPressed: () {
                ref
                    .read(settingsRepositoryProvider)
                    .setGhostMode(const Duration(hours: 24));
                context.pop();
              },
              child: const Text('24 Hours'),
            ),
          ],
        );
      },
    );
  }
}
