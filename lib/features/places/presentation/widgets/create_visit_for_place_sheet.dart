import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../groups/data/repositories/supabase_groups_repository.dart';
import '../../../groups/domain/entities/group.dart';
import '../../../groups/presentation/providers/groups_provider.dart';

class CreateVisitForPlaceSheet extends ConsumerStatefulWidget {
  final String placeId;
  final String placeName;

  const CreateVisitForPlaceSheet({
    super.key,
    required this.placeId,
    required this.placeName,
  });

  @override
  ConsumerState<CreateVisitForPlaceSheet> createState() =>
      _CreateVisitForPlaceSheetState();
}

class _CreateVisitForPlaceSheetState
    extends ConsumerState<CreateVisitForPlaceSheet> {
  final Set<String> _selectedGroupIds = {};
  DateTime _startTime = DateTime.now().add(const Duration(hours: 1));
  int _durationMinutes = 60;
  final _notesController = TextEditingController();
  bool _isLoading = false;
  List<Group> _availableGroups = [];
  bool _isLoadingGroups = true;

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) return;

      final groups = await ref
          .read(groupsRepositoryProvider)
          .fetchMyGroupsForPlace(currentUser.id, widget.placeId);

      if (mounted) {
        setState(() {
          _availableGroups = groups;
          _selectedGroupIds.addAll(groups.map((g) => g.id));
          _isLoadingGroups = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingGroups = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading groups: $e')));
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h${mins > 0 ? '${mins}m' : ''}';
    }
    return '${mins}m';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Plan a Visit to ${widget.placeName}',
                  style: Theme.of(context).textTheme.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visible to Groups',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (_isLoadingGroups)
                    const Center(child: CircularProgressIndicator())
                  else if (_availableGroups.isEmpty)
                    const Text(
                      'You are not in any groups that have this place.',
                    )
                  else
                    ..._availableGroups.map((group) {
                      return CheckboxListTile(
                        title: Text(group.name),
                        value: _selectedGroupIds.contains(group.id),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedGroupIds.add(group.id);
                            } else {
                              _selectedGroupIds.remove(group.id);
                            }
                          });
                        },
                      );
                    }),
                  const SizedBox(height: 24),

                  // Notes Field
                  TextField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Add a description or reason...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Date & Time Picker
                  ListTile(
                    title: const Text('Start Time'),
                    subtitle: Text(
                      '${DateFormat('MMM d, yyyy - h:mm a').format(_startTime)} - ${DateFormat('h:mm a').format(_startTime.add(Duration(minutes: _durationMinutes)))}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null && mounted) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_startTime),
                        );
                        if (time != null) {
                          setState(() {
                            _startTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Duration Slider
                  Text('Duration: ${_formatDuration(_durationMinutes)}'),
                  Slider(
                    value: _durationMinutes.toDouble(),
                    min: 15,
                    max: 240,
                    divisions: 15,
                    label: _formatDuration(_durationMinutes),
                    onChanged: (value) {
                      setState(() {
                        _durationMinutes = value.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading || _selectedGroupIds.isEmpty
                  ? null
                  : () async {
                      setState(() => _isLoading = true);
                      try {
                        final currentUser = ref.read(currentUserProvider);
                        final client = ref.read(supabaseClientProvider);
                        final repo = SupabaseGroupsRepository(client);

                        await repo.createPlannedVisitForGroups(
                          groupIds: _selectedGroupIds.toList(),
                          placeId: widget.placeId,
                          userId: currentUser!.id,
                          startTime: _startTime,
                          durationMinutes: _durationMinutes,
                          notes: _notesController.text,
                        );

                        // Invalidate providers for all affected groups
                        for (final groupId in _selectedGroupIds) {
                          ref.invalidate(groupPlannedVisitsProvider(groupId));
                        }

                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Visit planned!')),
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
                  : Text(
                      _selectedGroupIds.isEmpty
                          ? 'Select at least one group'
                          : 'Create Plan',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
