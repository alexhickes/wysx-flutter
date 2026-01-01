import 'package:flutter/material.dart';
import '../../../places/domain/entities/place_with_active_members.dart';

/// Widget that displays a stacked list of friend avatars
class StackedAvatars extends StatelessWidget {
  final List<ActiveMember> friends;
  final int maxVisible;
  final double avatarSize;

  const StackedAvatars({
    super.key,
    required this.friends,
    this.maxVisible = 3,
    this.avatarSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleFriends = friends.take(maxVisible).toList();
    final remainingCount = friends.length - visibleFriends.length;

    return SizedBox(
      height: avatarSize,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Stacked avatars
          SizedBox(
            width:
                avatarSize + (visibleFriends.length - 1) * (avatarSize * 0.6),
            child: Stack(
              children: visibleFriends.asMap().entries.map((entry) {
                final index = entry.key;
                final friend = entry.value;
                return Positioned(
                  left: index * (avatarSize * 0.6),
                  child: _buildAvatar(context, friend),
                );
              }).toList(),
            ),
          ),
          // "+X more" badge
          if (remainingCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '+$remainingCount',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, ActiveMember friend) {
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          friend.initial,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: avatarSize * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
