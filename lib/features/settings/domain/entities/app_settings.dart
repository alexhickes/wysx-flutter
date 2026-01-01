import 'package:equatable/equatable.dart';

enum ThemeModePreference { system, light, dark }

enum GpsPerformanceMode { highAccuracy, balanced, lowPower }

class AppSettings extends Equatable {
  final ThemeModePreference themeMode;
  final bool gpsEnabled;
  final GpsPerformanceMode gpsPerformanceMode;
  final int gpsSyncFrequency; // minutes
  final DateTime? ghostModeUntil;

  const AppSettings({
    this.themeMode = ThemeModePreference.system,
    this.gpsEnabled = true,
    this.gpsPerformanceMode = GpsPerformanceMode.balanced,
    this.gpsSyncFrequency = 15,
    this.ghostModeUntil,
  });

  AppSettings copyWith({
    ThemeModePreference? themeMode,
    bool? gpsEnabled,
    GpsPerformanceMode? gpsPerformanceMode,
    int? gpsSyncFrequency,
    DateTime? ghostModeUntil,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      gpsEnabled: gpsEnabled ?? this.gpsEnabled,
      gpsPerformanceMode: gpsPerformanceMode ?? this.gpsPerformanceMode,
      gpsSyncFrequency: gpsSyncFrequency ?? this.gpsSyncFrequency,
      ghostModeUntil: ghostModeUntil ?? this.ghostModeUntil,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    gpsEnabled,
    gpsPerformanceMode,
    gpsSyncFrequency,
    ghostModeUntil,
  ];
}
