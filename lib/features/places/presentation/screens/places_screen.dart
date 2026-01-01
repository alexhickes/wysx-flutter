import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/app_header.dart';

import '../providers/places_provider.dart';
import '../../../groups/presentation/screens/create_group_screen.dart';
import '../../../../core/presentation/widgets/custom_bottom_sheet.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Places'),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'My Places'),
              Tab(text: 'Invited'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [_MyPlacesTab(), _InvitedPlacesTab()],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'places_screen_fab',
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const CustomBottomSheet(
              title: 'Create Group',
              child: CreateGroupForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _MyPlacesTab extends ConsumerWidget {
  const _MyPlacesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesAsync = ref.watch(myPlacesProvider);

    return placesAsync.when(
      data: (places) {
        if (places.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.place_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No places yet'),
                Text('Create your first place to start sharing'),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: places.length,
          itemBuilder: (context, index) {
            final placeWithMembers = places[index];
            final place = placeWithMembers.place;
            final activeMembers = placeWithMembers.activeMembers;

            return ListTile(
              leading: const Icon(Icons.place),
              title: Text(place.name),
              subtitle: activeMembers.isNotEmpty
                  ? Text(
                      placeWithMembers.activityDescription,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Text(place.description ?? ''),
              onTap: () {
                print('DEBUG: Tapped My Place: ${place.name} (${place.id})');
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

class _InvitedPlacesTab extends ConsumerWidget {
  const _InvitedPlacesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesAsync = ref.watch(invitedPlacesProvider);

    return placesAsync.when(
      data: (places) {
        if (places.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No invites yet'),
                Text('When friends invite you, places will appear here'),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: places.length,
          itemBuilder: (context, index) {
            final placeWithMembers = places[index];
            final place = placeWithMembers.place;
            final activeMembers = placeWithMembers.activeMembers;

            return ListTile(
              leading: const Icon(Icons.place),
              title: Text(place.name),
              subtitle: activeMembers.isNotEmpty
                  ? Text(
                      placeWithMembers.activityDescription,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Text(place.description ?? ''),
              trailing: const Chip(label: Text('Invited')),
              onTap: () {
                print(
                  'DEBUG: Tapped Invited Place: ${place.name} (${place.id})',
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
