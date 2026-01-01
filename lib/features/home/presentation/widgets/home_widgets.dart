import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../features/home/domain/entities/check_in.dart';
import '../../../../features/groups/domain/entities/planned_visit.dart';
import '../../../../features/places/domain/entities/place.dart';

class ActiveCheckInCard extends StatelessWidget {
  final CheckIn checkIn;

  const ActiveCheckInCard({super.key, required this.checkIn});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      checkIn.place?.name ?? 'Unknown Place',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (checkIn.activity != null) ...[
              const SizedBox(height: 8),
              Text(
                '${checkIn.activity?.icon ?? ""} ${checkIn.activity?.name}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Since ${DateFormat('h:mm a').format(checkIn.checkedInAt)}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                if (checkIn.group != null) ...[
                  const SizedBox(width: 8),
                  Text('•', style: TextStyle(color: Colors.grey[500])),
                  const SizedBox(width: 8),
                  Text(
                    checkIn.group!.name,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FriendCheckInPlaceCard extends StatelessWidget {
  final Place place;
  final List<CheckIn> checkIns;
  final VoidCallback onTap;

  const FriendCheckInPlaceCard({
    super.key,
    required this.place,
    required this.checkIns,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getPlaceIcon(place.placeType),
                        size: 24,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${checkIns.length} ${checkIns.length == 1 ? 'person' : 'people'} here',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green, // Updated to green
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...checkIns.map((checkIn) => _buildPersonRow(context, checkIn)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonRow(BuildContext context, CheckIn checkIn) {
    final user = checkIn.user;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: user?.avatarUrl != null
                ? NetworkImage(user!.avatarUrl!)
                : null,
            child: user?.avatarUrl == null
                ? Text(
                    (user?.displayName ?? user?.username ?? '?')[0]
                        .toUpperCase(),
                    style: const TextStyle(fontSize: 12),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? user?.username ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  _formatTimeAgo(checkIn.checkedInAt),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          if (checkIn.activity != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (checkIn.activity?.icon != null)
                    Text(checkIn.activity!.icon!),
                  if (checkIn.activity?.icon != null) const SizedBox(width: 4),
                  Text(
                    checkIn.activity!.name,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  IconData _getPlaceIcon(String? type) {
    switch (type) {
      case 'skatepark':
        return Icons
            .skateboarding_outlined; // Trying specific if available, else fallback
      case 'gym':
        return Icons.fitness_center_outlined;
      case 'climbing':
        return Icons.hiking_outlined; // Best approximation
      case 'cafe':
        return Icons.local_cafe_outlined;
      case 'coworking':
        return Icons.computer_outlined;
      case 'park':
        return Icons.park_outlined;
      case 'sports':
        return Icons.sports_soccer_outlined;
      default:
        return Icons.place_outlined;
    }
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class UpcomingVisitCard extends StatelessWidget {
  final PlannedVisit visit;
  // final Place? place; // Commented out unused field

  const UpcomingVisitCard({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Visit planned for ${DateFormat('MMM d, h:mm a').format(visit.plannedAt)}',
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityFeedItem extends StatelessWidget {
  final CheckIn activity;

  const ActivityFeedItem({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final user = activity.user;
    final place = activity.place;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: user?.avatarUrl != null
                      ? NetworkImage(user!.avatarUrl!)
                      : null,
                  child: user?.avatarUrl == null
                      ? Text(
                          (user?.displayName ?? user?.username ?? '?')[0]
                              .toUpperCase(),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? user?.username ?? 'Unknown',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _formatDate(activity.checkedInAt),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.place_outlined, size: 16, color: Colors.black),
                const SizedBox(width: 4),
                Text(
                  place?.name ?? "Unknown Place",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (activity.activity != null) ...[
                  Text(
                    'Activity',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${activity.activity?.icon ?? ""} ${activity.activity?.name}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 16),
                ],
                if (activity.checkedOutAt != null) ...[
                  Text(
                    'Duration',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDuration(
                      activity.checkedInAt,
                      activity.checkedOutAt!,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    if (date.day == DateTime.now().day) {
      return 'Today at ${DateFormat('h:mm a').format(date)}';
    }
    return DateFormat('MMM d, h:mm a').format(date);
  }

  String _formatDuration(DateTime start, DateTime end) {
    final diff = end.difference(start);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}
