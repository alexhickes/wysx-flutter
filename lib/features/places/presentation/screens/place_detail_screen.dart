import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/app_header.dart';
import '../providers/places_provider.dart';

class PlaceDetailScreen extends ConsumerWidget {
  final String placeId;

  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeAsync = ref.watch(placeDetailsProvider(placeId));

    return Scaffold(
      appBar: const AppHeader(title: 'Place Details'),
      body: placeAsync.when(
        data: (place) {
          if (place == null) {
            return const Center(child: Text('Place not found'));
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                place.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              if (place.address != null) ...[
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        place.address!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              if (place.description != null) ...[
                Text(
                  place.description!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
              ],
              const Divider(),
              ListTile(
                leading: const Icon(Icons.public),
                title: const Text('Visibility'),
                subtitle: Text(place.isPublic ? 'Public' : 'Private'),
              ),
              ListTile(
                leading: const Icon(Icons.sync),
                title: const Text('Sync Status'),
                subtitle: Text(place.syncStatus.toUpperCase()),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
