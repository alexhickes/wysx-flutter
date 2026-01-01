import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'widgets/wysx_map.dart';
import '../../../shared/widgets/location_search_input.dart';

import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../core/presentation/widgets/app_header.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();
  bool _isLocationEnabled = true;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _checkLocationStatus();
  }

  Future<void> _checkLocationStatus() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        setState(() {
          _isLocationEnabled = false;
          _isLoadingLocation = false;
        });
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          setState(() {
            _isLocationEnabled = false;
            _isLoadingLocation = false;
          });
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() {
          _isLocationEnabled = false;
          _isLoadingLocation = false;
        });
      }
      return;
    }

    // Permissions granted: Try to get last known position first for speed
    final lastKnownPosition = await Geolocator.getLastKnownPosition();
    if (lastKnownPosition != null && mounted) {
      _mapController.move(
        LatLng(lastKnownPosition.latitude, lastKnownPosition.longitude),
        15.0,
      );
    }

    // Continue to get current precise position
    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _isLocationEnabled = true;
          _isLoadingLocation = false;
        });
        _mapController.move(
          LatLng(position.latitude, position.longitude),
          15.0,
        );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
          // Keep existing location (e.g., last known or default)
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Map'),
      body: Stack(
        children: [
          WysxMap(mapController: _mapController),
          // Search Input
          Positioned(
            top: _isLocationEnabled ? 60 : 120, // Adjust based on banner
            left: 16,
            right: 16,
            child: LocationSearchInput(
              onPlaceSelected: (place) {
                final lat = double.tryParse(place['lat'].toString());
                final lon = double.tryParse(place['lon'].toString());
                if (lat != null && lon != null) {
                  _mapController.move(LatLng(lat, lon), 15.0);
                }
              },
            ),
          ),
          // Location Disabled Banner
          if (!_isLocationEnabled && !_isLoadingLocation)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Theme.of(context).colorScheme.error,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      const Icon(Icons.location_off, color: Colors.white),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Location services disabled',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await Geolocator.openLocationSettings();
                          _checkLocationStatus();
                        },
                        child: const Text(
                          'ENABLE',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'map_fab',
        onPressed: () {
          WoltModalSheet.show(
            context: context,
            pageListBuilder: (modalSheetContext) {
              return [
                WoltModalSheetPage(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Places',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        const Text('List of nearby places will appear here.'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Implement stacked navigation using correct API
                            debugPrint('View Details pressed');
                          },
                          child: const Text('View Details (Stack Example)'),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
          );
        },
        child: const Icon(Icons.list),
      ),
    );
  }
}
