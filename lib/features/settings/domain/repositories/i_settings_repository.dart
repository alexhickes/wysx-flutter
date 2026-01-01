import '../entities/app_settings.dart';

abstract class ISettingsRepository {
  Stream<AppSettings> get settingsStream;
  Future<AppSettings> getSettings();
  Future<void> updateThemeMode(ThemeModePreference mode);
  Future<void> updateGpsEnabled(bool enabled);
  Future<void> updateGpsPerformanceMode(GpsPerformanceMode mode);
  Future<void> updateGpsSyncFrequency(int minutes);
  Future<void> setGhostMode(Duration? duration); // null to disable
}
