import 'package:drift/drift.dart';
import '../../../../core/services/app_database.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/i_settings_repository.dart';

class DriftSettingsRepository implements ISettingsRepository {
  final AppDatabase _db;

  DriftSettingsRepository(this._db);

  @override
  Stream<AppSettings> get settingsStream {
    return _db.select(_db.settingsTable).watchSingle().map(_toEntity);
  }

  @override
  Future<AppSettings> getSettings() async {
    final settings = await _db.select(_db.settingsTable).getSingleOrNull();
    if (settings == null) {
      // Initialize default settings if not exists
      await _db
          .into(_db.settingsTable)
          .insert(
            const SettingsTableCompanion(id: Value(1)),
            mode: InsertMode.insertOrIgnore,
          );
      return const AppSettings();
    }
    return _toEntity(settings);
  }

  AppSettings _toEntity(SettingsTableData data) {
    return AppSettings(
      themeMode: _parseThemeMode(data.themeMode),
      gpsEnabled: data.gpsEnabled,
      gpsPerformanceMode: _parseGpsPerformanceMode(data.gpsPerformanceMode),
      gpsSyncFrequency: data.gpsSyncFrequency,
      ghostModeUntil: data.ghostModeUntil,
    );
  }

  ThemeModePreference _parseThemeMode(String value) {
    return ThemeModePreference.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ThemeModePreference.system,
    );
  }

  GpsPerformanceMode _parseGpsPerformanceMode(String value) {
    return GpsPerformanceMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => GpsPerformanceMode.balanced,
    );
  }

  Future<void> _update(SettingsTableCompanion companion) async {
    // Ensure row exists
    await getSettings();
    await (_db.update(
      _db.settingsTable,
    )..where((t) => t.id.equals(1))).write(companion);
  }

  @override
  Future<void> updateThemeMode(ThemeModePreference mode) async {
    await _update(SettingsTableCompanion(themeMode: Value(mode.name)));
  }

  @override
  Future<void> updateGpsEnabled(bool enabled) async {
    await _update(SettingsTableCompanion(gpsEnabled: Value(enabled)));
  }

  @override
  Future<void> updateGpsPerformanceMode(GpsPerformanceMode mode) async {
    await _update(SettingsTableCompanion(gpsPerformanceMode: Value(mode.name)));
  }

  @override
  Future<void> updateGpsSyncFrequency(int minutes) async {
    await _update(SettingsTableCompanion(gpsSyncFrequency: Value(minutes)));
  }

  @override
  Future<void> setGhostMode(Duration? duration) async {
    final until = duration == null ? null : DateTime.now().add(duration);
    await _update(SettingsTableCompanion(ghostModeUntil: Value(until)));
  }
}
