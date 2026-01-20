import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/places/presentation/providers/places_provider.dart';
import '../../../../features/places/domain/entities/place_with_active_members.dart';

class MapPlacesList extends ConsumerWidget {
  const MapPlacesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesAsync = ref.watch(allPlacesWithActiveMembersProvider);
    final userLocationAsync = ref.watch(currentLocationProvider);

    return placesAsync.when(
      data: (places) {
        if (places.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('No places found.'),
            ),
          );
        }

        return userLocationAsync.when(
          data: (userLocation) {
            // Sort places
            final sortedPlaces = List<PlaceWithActiveMembers>.from(places);
            if (userLocation != null) {
              sortedPlaces.sort((a, b) {
                final distA = Geolocator.distanceBetween(
                  userLocation.latitude,
                  userLocation.longitude,
                  a.place.latitude,
                  a.place.longitude,
                );
                final distB = Geolocator.distanceBetween(
                  userLocation.latitude,
                  userLocation.longitude,
                  b.place.latitude,
                  b.place.longitude,
                );

                // Primary Sort: Distance (Ascending)
                final distanceComparison = distA.compareTo(distB);
                if (distanceComparison != 0) {
                  return distanceComparison;
                }

                // Secondary Sort: Active Member Count (Descending)
                return b.activeMembers.length.compareTo(a.activeMembers.length);
              });
            } else {
              // Fallback if no location: Sort only by popularity
              sortedPlaces.sort(
                (a, b) =>
                    b.activeMembers.length.compareTo(a.activeMembers.length),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Places Nearby',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedPlaces.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final placeWithMembers = sortedPlaces[index];
                      final place = placeWithMembers.place;
                      final distance = userLocation != null
                          ? Geolocator.distanceBetween(
                              userLocation.latitude,
                              userLocation.longitude,
                              place.latitude,
                              place.longitude,
                            )
                          : null;

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          child: Icon(
                            Icons.place,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          place.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: [
                            if (distance != null) ...[
                              Icon(
                                Icons.directions_walk,
                                size: 14,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDistance(distance),
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            if (placeWithMembers.activeMembers.isNotEmpty) ...[
                              const Icon(Icons.people, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${placeWithMembers.activeMembers.length}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          context.push('/places/${place.id}');
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, __) =>
              const SizedBox(), // Location error, maybe handled by parent or fallback to list
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()}m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)}km';
    }
  }
}
