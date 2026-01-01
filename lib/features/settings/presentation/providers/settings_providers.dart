import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/database_provider.dart';

import '../../data/repositories/drift_settings_repository.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/i_settings_repository.dart';

final settingsRepositoryProvider = Provider<ISettingsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftSettingsRepository(db);
});

final settingsProvider = StreamProvider<AppSettings>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return repository.settingsStream;
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  final settingsAsync = ref.watch(settingsProvider);
  return settingsAsync.when(
    data: (settings) {
      switch (settings.themeMode) {
        case ThemeModePreference.light:
          return ThemeMode.light;
        case ThemeModePreference.dark:
          return ThemeMode.dark;
        case ThemeModePreference.system:
          return ThemeMode.system;
      }
    },
    loading: () => ThemeMode.system,
    error: (_, __) => ThemeMode.system,
  );
});
