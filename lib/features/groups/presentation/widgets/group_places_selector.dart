import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../places/domain/entities/place.dart';
import '../../../places/presentation/providers/places_provider.dart';
import '../../../places/presentation/widgets/create_place_sheet.dart';
import '../../domain/repositories/i_groups_repository.dart';

class GroupPlacesSelector extends ConsumerStatefulWidget {
  final Function(List<GroupPlaceData>) onChanged;

  const GroupPlacesSelector({super.key, required this.onChanged});

  @override
  ConsumerState<GroupPlacesSelector> createState() =>
      _GroupPlacesSelectorState();
}

class _GroupPlacesSelectorState extends ConsumerState<GroupPlacesSelector> {
  final List<GroupPlaceData> _selectedPlaces = [];
  // Map to store full Place objects for display
  final Map<String, Place> _placeDetails = {};

  void _addPlace(Place place) {
    if (_selectedPlaces.any((p) => p.placeId == place.id)) return;

    setState(() {
      _placeDetails[place.id] = place;
      _selectedPlaces.add(
        GroupPlaceData(
          placeId: place.id,
          radius: 100.0,
          description: '',
          placeType: 'skatepark',
        ),
      );
    });
    widget.onChanged(_selectedPlaces);
  }

  void _removePlace(String placeId) {
    setState(() {
      _selectedPlaces.removeWhere((p) => p.placeId == placeId);
    });
    widget.onChanged(_selectedPlaces);
  }

  void _updatePlaceData(int index, GroupPlaceData newData) {
    setState(() {
      _selectedPlaces[index] = newData;
    });
    widget.onChanged(_selectedPlaces);
  }

  void _showCreatePlaceSheet() async {
    final result = await showModalBottomSheet<Place>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreatePlaceSheet(),
    );

    if (result != null) {
      _addPlace(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final placesAsync = ref.watch(myPlacesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Places',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Place Selector Dropdown & Create Button
        Row(
          children: [
            Expanded(
              child: placesAsync.when(
                data: (places) => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Add a Place',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: places.map((placeWithMembers) {
                    final place = placeWithMembers.place;
                    // Cache place details
                    _placeDetails[place.id] = place;
                    return DropdownMenuItem(
                      value: place.id,
                      child: Text(place.name, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (placeId) {
                    if (placeId != null) {
                      final place = places
                          .firstWhere((p) => p.place.id == placeId)
                          .place;
                      _addPlace(place);
                    }
                  },
                  // Reset value after selection to allow selecting another
                  initialValue: null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Error loading places'),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _showCreatePlaceSheet,
              icon: const Icon(Icons.add_location_alt),
              tooltip: 'Create New Place',
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Selected Places List
        if (_selectedPlaces.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'No places selected. Add existing places or create new ones.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _selectedPlaces.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final placeData = _selectedPlaces[index];
              final place = _placeDetails[placeData.placeId];

              return Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          const Icon(Icons.place, color: Colors.purple),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              place?.name ?? 'Unknown Place',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () => _removePlace(placeData.placeId),
                          ),
                        ],
                      ),
                      const Divider(),

                      // Settings Fields
                      const SizedBox(height: 8),

                      // Radius Slider
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Radius'),
                              Text(
                                '${placeData.radius.round()} m',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: placeData.radius,
                            min: 50,
                            max: 5000,
                            divisions: 99,
                            label: '${placeData.radius.round()} m',
                            onChanged: (val) {
                              _updatePlaceData(
                                index,
                                GroupPlaceData(
                                  placeId: placeData.placeId,
                                  radius: val,
                                  description: placeData.description,
                                  placeType: placeData.placeType,
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

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
                              final selectedTypes = placeData.placeType.split(
                                ',',
                              );
                              final isSelected = selectedTypes.contains(type);
                              return FilterChip(
                                label: Text(
                                  type[0].toUpperCase() + type.substring(1),
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  final currentTypes =
                                      placeData.placeType.isEmpty
                                      ? <String>[]
                                      : placeData.placeType.split(',');

                                  if (selected) {
                                    currentTypes.add(type);
                                  } else {
                                    currentTypes.remove(type);
                                  }

                                  _updatePlaceData(
                                    index,
                                    GroupPlaceData(
                                      placeId: placeData.placeId,
                                      radius: placeData.radius,
                                      description: placeData.description,
                                      placeType: currentTypes.join(','),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                      ),

                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: placeData.description,
                        decoration: const InputDecoration(
                          labelText: 'Description for Group',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) {
                          _updatePlaceData(
                            index,
                            GroupPlaceData(
                              placeId: placeData.placeId,
                              radius: placeData.radius,
                              description: val,
                              placeType: placeData.placeType,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
