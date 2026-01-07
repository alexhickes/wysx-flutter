import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/social_providers.dart';
import '../widgets/friend_list_item.dart';
import '../widgets/user_search_autocomplete.dart';

class FriendsTab extends ConsumerWidget {
  const FriendsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);
    final incomingAsync = ref.watch(incomingRequestsProvider);
    final sentAsync = ref.watch(sentRequestsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        // Providers are auto-refreshing streams, but we can force refresh if needed
        // ref.refresh(friendsProvider);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search Bar
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: UserSearchAutocomplete(),
          ),

          // Invites Section
          incomingAsync.when(
            data: (requests) {
              if (requests.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invites (${requests.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...requests.map((req) => FriendListItem.invite(request: req)),
                  const SizedBox(height: 16),
                ],
              );
            },
            loading: () => const Center(child: LinearProgressIndicator()),
            error: (err, _) => Text('Error loading invites: $err'),
          ),

          // Friends Section
          friendsAsync.when(
            data: (friends) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Friends (${friends.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (friends.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('No friends yet. Add some!'),
                    ),
                  ...friends.map(
                    (friend) => FriendListItem.friend(friend: friend),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Error loading friends: $err'),
          ),

          const SizedBox(height: 16),

          // Sent Requests Section
          sentAsync.when(
            data: (requests) {
              if (requests.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sent Requests (${requests.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...requests.map((req) => FriendListItem.sent(request: req)),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
