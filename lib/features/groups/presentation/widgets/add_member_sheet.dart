import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/supabase_groups_repository.dart';
import 'friend_selector.dart';

class AddMemberSheet extends ConsumerStatefulWidget {
  final String groupId;

  const AddMemberSheet({super.key, required this.groupId});

  @override
  ConsumerState<AddMemberSheet> createState() => _AddMemberSheetState();
}

class _AddMemberSheetState extends ConsumerState<AddMemberSheet> {
  List<String> _selectedFriendIds = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add Members', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          Expanded(
            child: FriendSelector(
              selectedFriendIds: _selectedFriendIds,
              onChanged: (ids) {
                setState(() {
                  _selectedFriendIds = ids;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading || _selectedFriendIds.isEmpty
                  ? null
                  : () async {
                      setState(() => _isLoading = true);
                      try {
                        final currentUser = ref.read(currentUserProvider);
                        final client = ref.read(supabaseClientProvider);
                        final repo = SupabaseGroupsRepository(client);

                        await repo.inviteMembersToGroup(
                          widget.groupId,
                          currentUser!.id,
                          _selectedFriendIds,
                        );

                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invitations sent!')),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      } finally {
                        if (mounted) {
                          setState(() => _isLoading = false);
                        }
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Invite Selected'),
            ),
          ),
        ],
      ),
    );
  }
}
