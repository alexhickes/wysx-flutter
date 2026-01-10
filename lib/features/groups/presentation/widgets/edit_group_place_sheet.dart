import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wysx/features/groups/data/repositories/supabase_groups_repository.dart';
import 'package:wysx/features/places/data/repositories/supabase_places_repository.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/groups_provider.dart';

class EditGroupPlaceSheet extends ConsumerStatefulWidget {
  final String groupId;
  final Map<String, dynamic> placeData;

  const EditGroupPlaceSheet({
    super.key,
    required this.groupId,
    required this.placeData,
  });

  @override
  ConsumerState<EditGroupPlaceSheet> createState() =>
      _EditGroupPlaceSheetState();
}

class _EditGroupPlaceSheetState extends ConsumerState<EditGroupPlaceSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _radiusController;
  late TextEditingController _typeController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final place = widget.placeData['places'];
    _nameController = TextEditingController(text: place['name']);
    _descriptionController = TextEditingController(
      text: widget.placeData['description'] ?? '',
    );
    _radiusController = TextEditingController(
      text: widget.placeData['radius'].toString(),
    );

    // Handle place_type which comes as a List from Supabase
    final types = widget.placeData['place_type'];
    String typeStr = '';
    if (types is List) {
      typeStr = types.join(', ');
    } else if (types is String) {
      typeStr = types; // Fallback if it comes as string somehow
    }
    _typeController = TextEditingController(text: typeStr);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _radiusController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  Future<void> _updatePlace() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final client = ref.read(supabaseClientProvider);
      final groupsRepo = SupabaseGroupsRepository(client);
      final placesRepo = SupabasePlacesRepository(client);

      final place = widget.placeData['places'];
      final placeId = place['id'];

      // 1. Update global place name if changed
      if (_nameController.text != place['name']) {
        await placesRepo.updatePlace(placeId, {'name': _nameController.text});
      }

      // 2. Update group specific settings
      final radius = double.tryParse(_radiusController.text);
      final typeList = _typeController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      await groupsRepo.updateGroupPlace(
        widget.groupId,
        placeId,
        radius: radius,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        placeType: typeList.isNotEmpty ? typeList : null,
      );

      // Refresh the group places provider
      ref.invalidate(groupPlacesProvider(widget.groupId));

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Place updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating place: $e')));
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
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Edit Place', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Place Name',
                  helperText: 'Updates name for everyone',
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

              // Radius Slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Radius'),
                      Text(
                        '${_radiusController.text} m',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: double.tryParse(_radiusController.text) ?? 100,
                    min: 10,
                    max: 1000,
                    divisions: 99,
                    label: _radiusController.text,
                    onChanged: (val) {
                      setState(() {
                        _radiusController.text = val.round().toString();
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Place Type Chips
              const Text('Place Types'),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children:
                    [
                      'skatepark',
                      'gym',
                      'climbing',
                      'cafe',
                      'coworking',
                      'park',
                      'sports',
                      'other',
                    ].map((type) {
                      final currentTypes = _typeController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();
                      final isSelected = currentTypes.contains(type);

                      return FilterChip(
                        label: Text(type[0].toUpperCase() + type.substring(1)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              currentTypes.add(type);
                            } else {
                              currentTypes.remove(type);
                            }
                            _typeController.text = currentTypes.join(',');
                          });
                        },
                      );
                    }).toList(),
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _updatePlace,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Changes'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
