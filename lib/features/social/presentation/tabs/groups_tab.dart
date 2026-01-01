import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../groups/presentation/providers/groups_provider.dart';

class GroupsTab extends ConsumerWidget {
  const GroupsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(myGroupsWithStatsProvider);

    return Scaffold(
      body: groupsAsync.when(
        data: (groupsWithStats) {
          if (groupsWithStats.isEmpty) {
            return const Center(child: Text('No groups yet. Create one!'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: groupsWithStats.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final groupWithStats = groupsWithStats[index];
              final group = groupWithStats.group;
              return ListTile(
                leading: const Icon(Icons.group),
                title: Text(group.name),
                subtitle: Text(
                  groupWithStats.activityDescription,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/groups/${group.id}');
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
