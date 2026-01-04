import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/places/domain/entities/place.dart';
import '../../../../features/places/domain/entities/place_with_active_members.dart';
import '../../../../features/places/presentation/providers/places_provider.dart';
import '../../../../features/places/presentation/screens/place_details_screen.dart';

class WysxMap extends ConsumerWidget {
  final LatLng? initialCenter;
  final MapController? mapController;

  const WysxMap({super.key, this.mapController, this.initialCenter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the provider that includes active member data
    final placesAsync = ref.watch(allPlacesWithActiveMembersProvider);

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter:
            initialCenter ?? const LatLng(51.505, -0.09), // London Default
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.wysx.app',
        ),
        placesAsync.when(
          data: (List<PlaceWithActiveMembers> places) => CircleLayer(
            circles: places
                .where((p) => p.place.radius != null)
                .map(
                  (pm) => CircleMarker(
                    point: LatLng(pm.place.latitude, pm.place.longitude),
                    radius: pm.place.radius!,
                    useRadiusInMeter: true,
                    color: AppColors.purple9.withOpacity(0.2),
                    borderColor: AppColors.purple9,
                    borderStrokeWidth: 2,
                  ),
                )
                .toList(),
          ),
          loading: () => const CircleLayer(circles: []),
          error: (_, __) => const CircleLayer(circles: []),
        ),
        placesAsync.when(
          data: (List<PlaceWithActiveMembers> places) => MarkerLayer(
            markers: places.map((pm) => _buildMarker(context, pm)).toList(),
          ),
          loading: () => const MarkerLayer(markers: []),
          error: (_, __) => const MarkerLayer(markers: []),
        ),
        // Blue Dot Current Location Layer
        ref
            .watch(currentLocationProvider)
            .when(
              data: (location) {
                if (location == null) return const MarkerLayer(markers: []);
                return MarkerLayer(
                  markers: [
                    Marker(
                      point: location,
                      width: 20,
                      height: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const MarkerLayer(markers: []),
              error: (_, __) => const MarkerLayer(markers: []),
            ),
      ],
    );
  }

  Marker _buildMarker(
    BuildContext context,
    PlaceWithActiveMembers placeWithMembers,
  ) {
    final place = placeWithMembers.place;
    final hasActiveMembers = placeWithMembers.activeMembers.isNotEmpty;

    Color color;
    switch (place.status) {
      case PlaceStatus.active:
        color = AppColors.purple9;
        break;
      case PlaceStatus.planned:
        color = Colors.orange;
        break;
      case PlaceStatus.inactive:
        color = Colors.grey;
    }

    // If members are active, override color or add indication
    if (hasActiveMembers) {
      color = Colors.green; // Example: Green if friends are there
    }

    return Marker(
      point: LatLng(place.latitude, place.longitude),
      width: 50, // Slightly larger to accommodate badging if needed
      height: 50,
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Allow full height if needed
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.25,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                // We wrap content in a container or just pass it
                // Note: PlaceDetailsContent uses ListView inside, updates needed there?
                // The ListView in PlaceDetailsContent should ideally use the scrollController
                // passed by DraggableScrollableSheet for smooth scrolling.
                // For now, let's just wrap it in a container
                // However, PlaceDetailsContent uses a standard ListView.
                // To make it draggable-friendly, we might need to pass the controller.
                // But for a simple modal bottom sheet, standard showModalBottomSheet is fine.
                // Let's stick to simple showModalBottomSheet first for simplicity as requested.
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 8),
                        width: 32,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Place Name Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        place.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(child: PlaceDetailsContent(placeId: place.id)),
                  ],
                );
              },
            ),
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.location_on, color: color, size: 40),
            if (hasActiveMembers)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${placeWithMembers.activeMembersCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
