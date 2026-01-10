import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/presentation/widgets/app_header.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/supabase_groups_repository.dart';
import '../providers/groups_provider.dart';
import '../widgets/add_place_sheet.dart';
import '../widgets/create_visit_sheet.dart';
import '../widgets/add_member_sheet.dart';
import '../widgets/edit_group_place_sheet.dart';

class GroupDetailsScreen extends ConsumerWidget {
  final String groupId;

  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupAsync = ref.watch(groupDetailsProvider(groupId));
    final membersAsync = ref.watch(groupMembersProvider(groupId));
    final placesAsync = ref.watch(groupPlacesProvider(groupId));
    final visitsAsync = ref.watch(groupPlannedVisitsProvider(groupId));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppHeader(title: groupAsync.value?.name ?? 'Group Details'),
      body: groupAsync.when(
        data: (group) {
          final isAdmin = group.createdBy == currentUser?.id;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(groupDetailsProvider(groupId));
              ref.invalidate(groupMembersProvider(groupId));
              ref.invalidate(groupPlacesProvider(groupId));
              ref.invalidate(groupPlannedVisitsProvider(groupId));
            },
            child: Container(
              color: Colors.grey[200],
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 8),

                  // Places Section
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
                          'Locations',
                          placesAsync.value?.length.toString(),
                          isAdmin
                              ? () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    showDragHandle: true,
                                    builder: (context) =>
                                        AddPlaceSheet(groupId: groupId),
                                  );
                                }
                              : null,
                        ),
                        placesAsync.when(
                          data: (places) {
                            if (places.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('No locations added yet.'),
                              );
                            }
                            return Column(
                              children: places.map((placeData) {
                                final place = placeData['places'];
                                return ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.place),
                                  ),
                                  title: Text(place['name']),
                                  subtitle: Text(
                                    '${placeData['radius']}m radius',
                                  ),
                                  trailing: isAdmin
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  showDragHandle: true,
                                                  builder: (context) =>
                                                      EditGroupPlaceSheet(
                                                        groupId: groupId,
                                                        placeData: placeData,
                                                      ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () async {
                                                final client = ref.read(
                                                  supabaseClientProvider,
                                                );
                                                final repo =
                                                    SupabaseGroupsRepository(
                                                      client,
                                                    );
                                                await repo.removePlaceFromGroup(
                                                  groupId,
                                                  place['id'],
                                                );
                                                ref.invalidate(
                                                  groupPlacesProvider(groupId),
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      : null,
                                  onTap: () {
                                    // Navigate to place details if implemented
                                  },
                                );
                              }).toList(),
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, s) => Text('Error: $e'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Planned Visits Section
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
                          visitsAsync.value?.length.toString(),
                          () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              showDragHandle: true,
                              builder: (context) =>
                                  CreateVisitSheet(groupId: groupId),
                            );
                          },
                        ),
                        visitsAsync.when(
                          data: (visits) {
                            if (visits.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('No upcoming visits.'),
                              );
                            }
                            return Column(
                              children: visits.map((visit) {
                                final place = visit['places'];
                                final user = visit['profiles'];
                                final startTime = DateTime.parse(
                                  visit['planned_at'],
                                );
                                final notes = visit['notes'] as String?;
                                final durationStr =
                                    visit['duration'] as String?;

                                // Try to parse duration from string (e.g. "01:00:00" or "60 minutes")
                                // For now, just display the string if present, or fallback to 60
                                String durationDisplay = '60m';
                                if (durationStr != null) {
                                  durationDisplay = durationStr;
                                }

                                return ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.calendar_today),
                                  ),
                                  title: Text(place['name']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${user['username']} • ${DateFormat('MMM d, h:mm a').format(startTime)} ($durationDisplay)',
                                      ),
                                      if (notes != null && notes.isNotEmpty)
                                        Text(
                                          notes,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, s) => Text('Error: $e'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Members Section
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
                          'Members',
                          membersAsync.value?.length.toString(),
                          () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              showDragHandle: true,
                              builder: (context) =>
                                  AddMemberSheet(groupId: groupId),
                            );
                          },
                        ),
                        membersAsync.when(
                          data: (members) {
                            return Column(
                              children: members.map((member) {
                                final profile = member['profiles'];
                                final role = member['role'];
                                final isMe =
                                    member['user_id'] == currentUser?.id;

                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        profile['avatar_url'] != null
                                        ? NetworkImage(profile['avatar_url'])
                                        : null,
                                    child: profile['avatar_url'] == null
                                        ? Text(
                                            profile['username'][0]
                                                .toUpperCase(),
                                          )
                                        : null,
                                  ),
                                  title: Text(
                                    profile['display_name'] ??
                                        profile['username'],
                                  ),
                                  subtitle: Text(
                                    '@${profile['username']} • $role',
                                  ),
                                  trailing: isAdmin && !isMe
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                          onPressed: () async {
                                            final client = ref.read(
                                              supabaseClientProvider,
                                            );
                                            final repo =
                                                SupabaseGroupsRepository(
                                                  client,
                                                );
                                            await repo.removeMemberFromGroup(
                                              groupId,
                                              member['user_id'],
                                            );
                                            ref.invalidate(
                                              groupMembersProvider(groupId),
                                            );
                                          },
                                        )
                                      : null,
                                );
                              }).toList(),
                            );
                          },

                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, s) => Text('Error: $e'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // My Permissions Section
                  membersAsync.maybeWhen(
                    data: (members) {
                      final myMember = members.firstWhere(
                        (m) => m['user_id'] == currentUser?.id,
                        orElse: () => <String, dynamic>{},
                      );

                      if (myMember.isEmpty) return const SizedBox.shrink();

                      final shareLocation = myMember['share_location'] ?? true;
                      final notificationsEnabled =
                          myMember['notifications_enabled'] ?? true;

                      return Column(
                        children: [
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
                                  'My Permissions',
                                  null,
                                  null,
                                ),
                                SwitchListTile(
                                  title: const Text('Share Location'),
                                  subtitle: const Text(
                                    'Allow group members to see your location',
                                  ),
                                  value: shareLocation,
                                  onChanged: (value) async {
                                    final client = ref.read(
                                      supabaseClientProvider,
                                    );
                                    final repo = SupabaseGroupsRepository(
                                      client,
                                    );
                                    await repo.updateMemberSettings(
                                      groupId,
                                      currentUser!.id,
                                      shareLocation: value,
                                    );
                                    ref.invalidate(
                                      groupMembersProvider(groupId),
                                    );
                                  },
                                ),
                                SwitchListTile(
                                  title: const Text('Notifications'),
                                  subtitle: const Text(
                                    'Receive notifications from this group',
                                  ),
                                  value: notificationsEnabled,
                                  onChanged: (value) async {
                                    final client = ref.read(
                                      supabaseClientProvider,
                                    );
                                    final repo = SupabaseGroupsRepository(
                                      client,
                                    );
                                    await repo.updateMemberSettings(
                                      groupId,
                                      currentUser!.id,
                                      notificationsEnabled: value,
                                    );
                                    ref.invalidate(
                                      groupMembersProvider(groupId),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                    orElse: () => const SizedBox.shrink(),
                  ),

                  // Settings Section
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(context, 'Settings', null, null),
                        SwitchListTile(
                          title: const Text('Public Group'),
                          subtitle: const Text(
                            'Allow anyone to find and join this group',
                          ),
                          value: group.isPublic,
                          onChanged: isAdmin
                              ? (value) async {
                                  final client = ref.read(
                                    supabaseClientProvider,
                                  );
                                  final repo = SupabaseGroupsRepository(client);
                                  await repo.updateGroup(groupId, {
                                    'is_public': value,
                                  });
                                  ref.invalidate(groupDetailsProvider(groupId));
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Leave Button Section
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Leave Group'),
                              content: Text(
                                'Are you sure you want to leave ${group.name}?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Leave'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            final client = ref.read(supabaseClientProvider);
                            final repo = SupabaseGroupsRepository(client);
                            await repo.leaveGroup(groupId, currentUser!.id);
                            if (context.mounted) {
                              context.go('/social');
                            }
                          }
                        },
                        icon: const Icon(Icons.exit_to_app),
                        label: const Text('Leave Group'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String? count,
    VoidCallback? onAdd,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$title ${count != null ? '($count)' : ''}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (onAdd != null)
          IconButton(
            onPressed: onAdd,
            icon: const Icon(Icons.add_circle_outline),
          ),
      ],
    );
  }
}
