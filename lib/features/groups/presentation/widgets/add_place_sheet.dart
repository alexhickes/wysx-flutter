import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/supabase_groups_repository.dart';
import '../../../places/data/repositories/supabase_places_repository.dart';
import '../providers/groups_provider.dart';
import '../../../places/presentation/providers/places_provider.dart';

class AddPlaceSheet extends ConsumerStatefulWidget {
  final String groupId;

  const AddPlaceSheet({super.key, required this.groupId});

  @override
  ConsumerState<AddPlaceSheet> createState() => _AddPlaceSheetState();
}

class _AddPlaceSheetState extends ConsumerState<AddPlaceSheet> {
  @override
  Widget build(BuildContext context) {
    final placesAsync = ref.watch(myPlacesProvider);

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Location',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: placesAsync.when(
              data: (places) {
                if (places.isEmpty) {
                  return const Center(
                    child: Text('You have no places to add.'),
                  );
                }
                return ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index].place;
                    return ListTile(
                      leading: const Icon(Icons.place),
                      title: Text(place.name),
                      subtitle: Text(place.address ?? 'No address'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          final currentUser = ref.read(currentUserProvider);
                          if (currentUser == null) return;

                          try {
                            final client = ref.read(supabaseClientProvider);

                            // Ensure place is synced to Supabase first
                            if (place.syncStatus != 'synced') {
                              final placesRepo = SupabasePlacesRepository(
                                client,
                              );
                              await placesRepo.createPlace(place);
                            }

                            final repo = SupabaseGroupsRepository(client);

                            await repo.addPlaceToGroup(
                              widget.groupId,
                              place.id,
                              currentUser.id,
                            );

                            ref.invalidate(groupPlacesProvider(widget.groupId));
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${place.name} added to group'),
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error adding place: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
