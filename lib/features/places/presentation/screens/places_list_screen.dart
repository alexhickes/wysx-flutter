import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/app_header.dart';
import '../providers/places_provider.dart';
import 'create_place_screen.dart';
import 'place_detail_screen.dart';

class PlacesListScreen extends ConsumerWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesAsync = ref.watch(nearbyPlacesProvider);

    return Scaffold(
      appBar: const AppHeader(title: 'Places'),
      body: placesAsync.when(
        data: (places) {
          if (places.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No places found nearby.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreatePlaceScreen(),
                        ),
                      );
                    },
                    child: const Text('Add a Place'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return ListTile(
                title: Text(place.name),
                subtitle: Text(place.description ?? 'No description'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PlaceDetailScreen(placeId: place.id),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'places_list_fab',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreatePlaceScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
