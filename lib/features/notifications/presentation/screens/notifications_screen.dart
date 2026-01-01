import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../social/presentation/providers/social_providers.dart';
import '../../../groups/presentation/providers/groups_provider.dart';
import '../../../groups/data/repositories/supabase_groups_repository.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendRequestsAsync = ref.watch(incomingRequestsProvider);
    final groupInvitesAsync = ref.watch(myPendingGroupInvitationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: [
          _buildSectionHeader('Friend Requests'),
          friendRequestsAsync.when(
            data: (requests) {
              if (requests.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No pending friend requests'),
                );
              }
              return Column(
                children: requests
                    .map(
                      (request) => ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(request.displayName ?? request.username),
                        subtitle: Text('@${request.username}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: () async {
                                await ref
                                    .read(socialRepositoryProvider)
                                    .acceptFriendRequest(request.userId);
                                ref.invalidate(incomingRequestsProvider);
                                ref.invalidate(friendsProvider);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () async {
                                await ref
                                    .read(socialRepositoryProvider)
                                    .rejectFriendRequest(request.userId);
                                ref.invalidate(incomingRequestsProvider);
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
          const Divider(),
          _buildSectionHeader('Group Invitations'),
          groupInvitesAsync.when(
            data: (invites) {
              if (invites.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No pending group invitations'),
                );
              }
              return Column(
                children: invites.map((invite) {
                  final group = invite['groups'];
                  final inviter = invite['inviter'];
                  final groupName = group != null
                      ? group['name']
                      : 'Unknown Group';
                  final inviterName = inviter != null
                      ? inviter['username']
                      : 'Unknown User';

                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.group)),
                    title: Text(groupName),
                    subtitle: Text('Invited by @$inviterName'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () async {
                            final client = ref.read(supabaseClientProvider);
                            final repo = SupabaseGroupsRepository(client);
                            await repo.acceptInvitation(invite['id']);
                            ref.invalidate(myPendingGroupInvitationsProvider);
                            ref.invalidate(myGroupsProvider);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () async {
                            final client = ref.read(supabaseClientProvider);
                            final repo = SupabaseGroupsRepository(client);
                            await repo.declineInvitation(invite['id']);
                            ref.invalidate(myPendingGroupInvitationsProvider);
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
