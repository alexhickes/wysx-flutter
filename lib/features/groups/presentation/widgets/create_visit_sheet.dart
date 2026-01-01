import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/supabase_groups_repository.dart';
import '../providers/groups_provider.dart';

class CreateVisitSheet extends ConsumerStatefulWidget {
  final String groupId;

  const CreateVisitSheet({super.key, required this.groupId});

  @override
  ConsumerState<CreateVisitSheet> createState() => _CreateVisitSheetState();
}

class _CreateVisitSheetState extends ConsumerState<CreateVisitSheet> {
  String? _selectedPlaceId;
  DateTime _startTime = DateTime.now().add(const Duration(hours: 1));
  int _durationMinutes = 60;
  final _notesController = TextEditingController();
  bool _isLoading = false;

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
    final placesAsync = ref.watch(groupPlacesProvider(widget.groupId));

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.8,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan a Visit',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Place Selector
            // Place Selector
            placesAsync.when(
              data: (places) {
                if (places.isEmpty) {
                  return const Text(
                    'No places in this group. Add a place first!',
                    style: TextStyle(color: Colors.red),
                  );
                }
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Location',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _selectedPlaceId,
                  items: places.map((placeData) {
                    final place = placeData['places'];
                    return DropdownMenuItem<String>(
                      value: place['id'],
                      child: Text(place['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPlaceId = value;
                    });
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text('Error loading places: $e'),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 16),

            // Notes Field
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Add a description or plan...',
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

            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading || _selectedPlaceId == null
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        try {
                          final currentUser = ref.read(currentUserProvider);
                          final client = ref.read(supabaseClientProvider);
                          final repo = SupabaseGroupsRepository(client);

                          await repo.createPlannedVisit(
                            groupId: widget.groupId,
                            placeId: _selectedPlaceId!,
                            userId: currentUser!.id,
                            startTime: _startTime,
                            durationMinutes: _durationMinutes,
                            notes: _notesController.text,
                          );

                          ref.invalidate(
                            groupPlannedVisitsProvider(widget.groupId),
                          );
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Visit planned!')),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() => _isLoading = false);
                          }
                        }
                      },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
