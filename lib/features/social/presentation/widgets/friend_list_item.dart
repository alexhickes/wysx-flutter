import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/social_user.dart';
import '../../domain/entities/friend_request.dart';
import '../providers/social_providers.dart';

enum FriendListItemType { invite, friend, sent }

class FriendListItem extends ConsumerWidget {
  final FriendListItemType type;
  final SocialUser? friend;
  final FriendRequest? request;

  const FriendListItem.friend({super.key, required this.friend})
    : type = FriendListItemType.friend,
      request = null;

  const FriendListItem.invite({super.key, required this.request})
    : type = FriendListItemType.invite,
      friend = null;

  const FriendListItem.sent({super.key, required this.request})
    : type = FriendListItemType.sent,
      friend = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = friend?.username ?? request?.username ?? '';
    final displayName = friend?.displayName ?? request?.displayName;
    final avatarUrl = friend?.avatarUrl ?? request?.avatarUrl;
    final initial = username.isNotEmpty ? username[0].toUpperCase() : '?';

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            child: avatarUrl == null ? Text(initial) : null,
          ),
          title: Text(displayName ?? username),
          subtitle: _buildSubtitle(context),
          trailing: _buildTrailing(context, ref),
        ),
        const SizedBox(height: 8), // Grey gap separator
      ],
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    final username = friend?.username ?? request?.username ?? '';
    final displayName = friend?.displayName ?? request?.displayName;

    if (type == FriendListItemType.friend) {
      if (friend!.locationName != null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (displayName != null)
              Text(
                '@$username',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            Text(
              'At ${friend!.locationName}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }
      return Text('@$username');
    }
    return Text('@$username');
  }

  Widget _buildTrailing(BuildContext context, WidgetRef ref) {
    if (type == FriendListItemType.friend) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: friend!.isSharingLocation,
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Per-friend sharing not yet supported'),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'remove') {
                ref.read(socialRepositoryProvider).removeFriend(friend!.id);
              } else if (value == 'block') {
                ref.read(socialRepositoryProvider).blockUser(friend!.id);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'remove',
                child: Text('Remove Friend'),
              ),
              const PopupMenuItem(value: 'block', child: Text('Block User')),
            ],
          ),
        ],
      );
    } else if (type == FriendListItemType.invite) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () {
              ref
                  .read(socialRepositoryProvider)
                  .acceptFriendRequest(request!.userId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              ref
                  .read(socialRepositoryProvider)
                  .rejectFriendRequest(request!.userId);
            },
          ),
        ],
      );
    } else {
      // sent
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Pending',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }
  }
}
