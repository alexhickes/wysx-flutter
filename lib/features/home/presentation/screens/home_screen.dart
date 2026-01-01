import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/app_header.dart';
import '../../../../features/places/domain/entities/place.dart';
import '../../domain/entities/check_in.dart';
import '../providers/home_providers.dart';
import '../widgets/home_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCheckInsAsync = ref.watch(myActiveCheckInsProvider);
    final friendsCheckInsAsync = ref.watch(friendsCheckInsProvider);
    final upcomingVisitsAsync = ref.watch(upcomingVisitsProvider);
    final recentActivityAsync = ref.watch(recentActivityProvider);

    return Scaffold(
      appBar: const AppHeader(title: 'Home'),
      backgroundColor: Colors.grey[200], // Match GroupDetailsScreen styling
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myActiveCheckInsProvider);
          ref.invalidate(friendsCheckInsProvider);
          ref.invalidate(upcomingVisitsProvider);
          ref.invalidate(recentActivityProvider);
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 8),

            // My Active Check-ins
            activeCheckInsAsync.when(
              data: (checkIns) {
                if (checkIns.isEmpty) return const SizedBox.shrink();
                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(context, 'Currently at'),
                      const SizedBox(height: 8),
                      ...checkIns.map((c) => ActiveCheckInCard(checkIn: c)),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Friends at Locations
            friendsCheckInsAsync.when(
              data: (checkIns) {
                if (checkIns.isEmpty) {
                  return _buildEmptySection(
                    context,
                    'Friends at locations',
                    'No friends are currently checked in',
                  );
                }

                // Grouping logic
                final Map<String, dynamic> placesMap = {}; // placeId -> Place
                final Map<String, List<CheckIn>> checkInsMap =
                    {}; // placeId -> List<CheckIn>

                for (var checkIn in checkIns) {
                  if (checkIn.placeId.isNotEmpty) {
                    if (!placesMap.containsKey(checkIn.placeId) &&
                        checkIn.place != null) {
                      placesMap[checkIn.placeId] = checkIn.place;
                    }
                    if (!checkInsMap.containsKey(checkIn.placeId)) {
                      checkInsMap[checkIn.placeId] = [];
                    }
                    checkInsMap[checkIn.placeId]!.add(checkIn);
                  }
                }

                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Friends at locations',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...checkInsMap.entries.map((entry) {
                        final placeId = entry.key;
                        final place = placesMap[placeId] as Place?;
                        if (place == null) return const SizedBox.shrink();
                        return FriendCheckInPlaceCard(
                          place: place,
                          checkIns: entry.value,
                          onTap: () {
                            // Navigate to place details
                          },
                        );
                      }),
                    ],
                  ),
                );
              },
              loading: () => _buildLoadingSection(context),
              error: (e, _) => _buildErrorSection(context, e.toString()),
            ),

            // Upcoming Visits
            upcomingVisitsAsync.when(
              data: (visits) {
                if (visits.isEmpty) {
                  return _buildEmptySection(
                    context,
                    'Upcoming visits',
                    'No upcoming visits planned',
                  );
                }
                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(context, 'Upcoming visits'),
                      const SizedBox(height: 8),
                      ...visits.map((v) => UpcomingVisitCard(visit: v)),
                    ],
                  ),
                );
              },
              loading: () => _buildLoadingSection(context),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Recent Activity
            recentActivityAsync.when(
              data: (activity) {
                if (activity.isEmpty) {
                  return _buildEmptySection(
                    context,
                    'Recent activity',
                    'No recent activity',
                  );
                }
                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(context, 'Recent activity'),
                      const SizedBox(height: 8),
                      ...activity.map((a) => ActivityFeedItem(activity: a)),
                    ],
                  ),
                );
              },
              loading: () => _buildLoadingSection(context),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 80), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _buildEmptySection(
    BuildContext context,
    String title,
    String message,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, title),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(message),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSection(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorSection(BuildContext context, String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Text(
        'Error loading section: $error',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
