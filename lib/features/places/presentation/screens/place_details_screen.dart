import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/presentation/widgets/app_header.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../groups/presentation/providers/groups_provider.dart';
import '../providers/places_provider.dart';

class PlaceDetailsScreen extends ConsumerWidget {
  final String placeId;

  const PlaceDetailsScreen({super.key, required this.placeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeAsync = ref.watch(placeWithActiveMembersProvider(placeId));
    final title = placeAsync.value?.place.name ?? 'Place Details';

    return Scaffold(
      appBar: AppHeader(title: title),
      body: PlaceDetailsContent(placeId: placeId),
    );
  }
}

class PlaceDetailsContent extends ConsumerStatefulWidget {
  final String placeId;

  const PlaceDetailsContent({super.key, required this.placeId});

  @override
  ConsumerState<PlaceDetailsContent> createState() =>
      _PlaceDetailsContentState();
}

class _PlaceDetailsContentState extends ConsumerState<PlaceDetailsContent> {
  bool _hideLocation = false;

  @override
  Widget build(BuildContext context) {
    final placeAsync = ref.watch(placeDetailsProvider(widget.placeId));
    final groupsAsync = ref.watch(groupsForPlaceProvider(widget.placeId));
    final visitsAsync = ref.watch(
      plannedVisitsForPlaceProvider(widget.placeId),
    );

    return placeAsync.when(
      data: (place) {
        if (place == null) {
          return const Center(child: Text('Place not found'));
        }
        return Container(
          color: Colors.grey[200],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 8),

              // Friends at Location
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        final placeWithMembersAsync = ref.watch(
                          placeWithActiveMembersProvider(widget.placeId),
                        );

                        return placeWithMembersAsync.when(
                          data: (placeWithMember) {
                            if (placeWithMember == null) {
                              return const SizedBox.shrink();
                            }

                            final friendsHere = placeWithMember.activeMembers;
                            print(
                              'DEBUG: PlaceDetailsContent Sheet - PlaceId: ${widget.placeId}',
                            );
                            print(
                              'DEBUG: Found place in provider. Active members count: ${friendsHere.length}',
                            );
                            for (var m in friendsHere) {
                              print('DEBUG: Active Member: ${m.name}');
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader(
                                  context,
                                  'Friends Here',
                                  friendsHere.length.toString(),
                                ),
                                if (friendsHere.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Text('No friends currently here'),
                                  )
                                else
                                  Column(
                                    children: friendsHere
                                        .map(
                                          (friend) => ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage:
                                                  friend.avatarUrl != null
                                                  ? NetworkImage(
                                                      friend.avatarUrl!,
                                                    )
                                                  : null,
                                              child: friend.avatarUrl == null
                                                  ? Text(friend.initial)
                                                  : null,
                                            ),
                                            title: Text(friend.name),
                                            subtitle: Text(
                                              'Checked in at ${DateFormat.jm().format(friend.checkedInAt ?? DateTime.now())}',
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                              ],
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (_, __) => const Text('Error loading friends'),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Planned Visits
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      context,
                      'Planned Visits',
                      visitsAsync.valueOrNull?.length.toString(),
                    ),
                    visitsAsync.when(
                      data: (visits) {
                        if (visits.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('No upcoming visits'),
                          );
                        }
                        return Column(
                          children: visits
                              .map(
                                (visit) => ListTile(
                                  leading: const Icon(Icons.calendar_today),
                                  title: Text(
                                    DateFormat.MMMEd().add_jm().format(
                                      visit.plannedAt,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${visit.durationMinutes} mins • ${visit.notes ?? "No notes"}',
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Text('Error loading visits'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Associated Groups
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      context,
                      'Groups',
                      groupsAsync.valueOrNull?.length.toString(),
                    ),
                    groupsAsync.when(
                      data: (groups) {
                        if (groups.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('No associated groups'),
                          );
                        }
                        return Column(
                          children: groups
                              .map(
                                (group) => ListTile(
                                  leading: const Icon(Icons.group),
                                  title: Text(group.name),
                                  subtitle: Text(group.description ?? ''),
                                  trailing: const Icon(
                                    Icons.chevron_right,
                                    size: 20,
                                  ),
                                  onTap: () {
                                    // Navigate to group details
                                    context.push('/groups/${group.id}');
                                  },
                                ),
                              )
                              .toList(),
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Text('Error loading groups'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Map Preview
              Container(
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(place.latitude, place.longitude),
                    initialZoom: 15.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.wysx.app',
                    ),
                    CircleLayer(
                      circles: [
                        if (place.radius != null)
                          CircleMarker(
                            point: LatLng(place.latitude, place.longitude),
                            radius: place.radius!,
                            useRadiusInMeter: true,
                            color: AppColors.purple9.withOpacity(0.15),
                            borderColor: AppColors.purple9,
                            borderStrokeWidth: 1,
                          ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(place.latitude, place.longitude),
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: AppColors.purple9,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Settings
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(context, 'Settings', null),
                    SwitchListTile(
                      title: const Text('Hide Location'),
                      subtitle: const Text('Hide your presence at this place'),
                      value: _hideLocation,
                      onChanged: (value) {
                        setState(() => _hideLocation = value);
                        // TODO: Persist this setting
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String? count,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '$title ${count != null ? '($count)' : ''}',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
