import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../social/presentation/providers/social_providers.dart';

class FriendSelector extends ConsumerStatefulWidget {
  final List<String> selectedFriendIds;
  final ValueChanged<List<String>> onChanged;

  const FriendSelector({
    super.key,
    required this.selectedFriendIds,
    required this.onChanged,
  });

  @override
  ConsumerState<FriendSelector> createState() => _FriendSelectorState();
}

class _FriendSelectorState extends ConsumerState<FriendSelector> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friendsAsync = ref.watch(friendsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Invite Friends',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search friends',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200, // Fixed height for the list
          child: friendsAsync.when(
            data: (friends) {
              final filteredFriends = friends.where((friend) {
                return friend.username.toLowerCase().contains(_searchQuery) ||
                    (friend.displayName?.toLowerCase().contains(_searchQuery) ??
                        false);
              }).toList();

              if (filteredFriends.isEmpty) {
                return const Center(child: Text('No friends found'));
              }

              return ListView.builder(
                itemCount: filteredFriends.length,
                itemBuilder: (context, index) {
                  final friend = filteredFriends[index];
                  final isSelected = widget.selectedFriendIds.contains(
                    friend.id,
                  );

                  return CheckboxListTile(
                    title: Text(friend.displayName ?? friend.username),
                    subtitle: friend.displayName != null
                        ? Text('@${friend.username}')
                        : null,
                    value: isSelected,
                    onChanged: (bool? value) {
                      final newSelection = List<String>.from(
                        widget.selectedFriendIds,
                      );
                      if (value == true) {
                        newSelection.add(friend.id);
                      } else {
                        newSelection.remove(friend.id);
                      }
                      widget.onChanged(newSelection);
                    },
                    secondary: CircleAvatar(
                      backgroundImage: friend.avatarUrl != null
                          ? NetworkImage(friend.avatarUrl!)
                          : null,
                      child: friend.avatarUrl == null
                          ? Text(friend.username[0].toUpperCase())
                          : null,
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }
}
