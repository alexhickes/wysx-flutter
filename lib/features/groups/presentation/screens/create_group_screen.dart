import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

import 'package:uuid/uuid.dart';
import '../../domain/entities/group.dart';
import '../../domain/repositories/i_groups_repository.dart';
import '../providers/groups_provider.dart';
import '../widgets/group_places_selector.dart';
import '../widgets/friend_selector.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Group')),
      body: const CreateGroupForm(),
    );
  }
}

class CreateGroupForm extends ConsumerStatefulWidget {
  const CreateGroupForm({super.key});

  @override
  ConsumerState<CreateGroupForm> createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends ConsumerState<CreateGroupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPublic = false;
  bool _requiresApproval = false;
  bool _autoCheckinEnabled = false;

  bool _notificationEnabled = true;

  List<GroupPlaceData> _selectedPlaces = [];
  List<String> _selectedFriendIds = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPlaces.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one place')),
      );
      return;
    }

    // ... inside _createGroup method ...

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to create a group'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final group = Group(
        id: const Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        createdBy: currentUser.id,
        createdAt: DateTime.now(),
        isPublic: _isPublic,
        requiresApproval: _requiresApproval,
        autoCheckinEnabled: _autoCheckinEnabled,
        notificationEnabled: _notificationEnabled,
      );

      await ref
          .read(groupsRepositoryProvider)
          .createGroup(group, _selectedPlaces, _selectedFriendIds);

      // Refresh the list
      ref.invalidate(myGroupsProvider);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group created successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating group: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        shrinkWrap: true, // Important for bottom sheet
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Group Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // Group Places Selector
          GroupPlacesSelector(
            onChanged: (places) {
              setState(() {
                _selectedPlaces = places;
              });
            },
          ),

          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Public Group'),
            subtitle: const Text('Anyone can find and join this group'),
            value: _isPublic,
            onChanged: (value) {
              setState(() {
                _isPublic = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Requires Approval'),
            subtitle: const Text('New members must be approved by admin'),
            value: _requiresApproval,
            onChanged: (value) {
              setState(() {
                _requiresApproval = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Auto Check-in'),
            subtitle: const Text('Automatically check in when nearby'),
            value: _autoCheckinEnabled,
            onChanged: (value) {
              setState(() {
                _autoCheckinEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Receive notifications for this group'),
            value: _notificationEnabled,
            onChanged: (value) {
              setState(() {
                _notificationEnabled = value;
              });
            },
          ),
          const SizedBox(height: 16),
          FriendSelector(
            selectedFriendIds: _selectedFriendIds,
            onChanged: (ids) {
              setState(() {
                _selectedFriendIds = ids;
              });
            },
          ),

          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _createGroup,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Create Group'),
          ),
          // Add extra padding at bottom for safe area
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20),
        ],
      ),
    );
  }
}
