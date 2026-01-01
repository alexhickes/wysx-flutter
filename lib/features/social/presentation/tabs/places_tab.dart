import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../places/presentation/providers/places_provider.dart';
import '../widgets/stacked_avatars.dart';

class PlacesTab extends ConsumerWidget {
  const PlacesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesAsync = ref.watch(allPlacesWithActiveMembersProvider);

    return placesAsync.when(
      data: (placesWithMembers) {
        if (placesWithMembers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.place_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No places found'),
                Text('Create a place or join a group to see places here'),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: placesWithMembers.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final placeWithMember = placesWithMembers[index];
            final place = placeWithMember.place;
            final activeMembers = placeWithMember.activeMembers;

            return ListTile(
              leading: const Icon(Icons.place),
              title: Text(place.name),
              subtitle: activeMembers.isNotEmpty
                  ? Row(
                      children: [
                        StackedAvatars(friends: activeMembers, avatarSize: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            placeWithMember.activityDescription,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Text(place.description ?? 'No friends here'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                print(
                  'DEBUG: Tapped Place in Social Tab: ${place.name} (${place.id})',
                );
                context.push('/places/${place.id}');
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
