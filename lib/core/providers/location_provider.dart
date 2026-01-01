import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  undetermined,
  disabled,
}

class LocationPermissionNotifier
    extends StateNotifier<LocationPermissionStatus> {
  LocationPermissionNotifier() : super(LocationPermissionStatus.undetermined) {
    checkPermission();
  }

  Future<void> checkPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = LocationPermissionStatus.disabled;
      return;
    }

    final permission = await Geolocator.checkPermission();
    _updateState(permission);
  }

  Future<void> requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = LocationPermissionStatus.disabled;
      return;
    }

    final permission = await Geolocator.requestPermission();
    _updateState(permission);
  }

  void _updateState(LocationPermission permission) {
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      state = LocationPermissionStatus.granted;
    } else if (permission == LocationPermission.denied) {
      state = LocationPermissionStatus.denied;
    } else if (permission == LocationPermission.deniedForever) {
      state = LocationPermissionStatus.deniedForever;
    }
  }

  Future<void> openSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}

final locationPermissionProvider =
    StateNotifierProvider<LocationPermissionNotifier, LocationPermissionStatus>(
      (ref) => LocationPermissionNotifier(),
    );
