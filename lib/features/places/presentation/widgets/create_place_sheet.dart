import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wysx/shared/widgets/location_search_input.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/presentation/widgets/custom_bottom_sheet.dart';
import '../../domain/entities/place.dart';
import '../providers/places_provider.dart';

class CreatePlaceSheet extends ConsumerStatefulWidget {
  const CreatePlaceSheet({super.key});

  @override
  ConsumerState<CreatePlaceSheet> createState() => _CreatePlaceSheetState();
}

class _CreatePlaceSheetState extends ConsumerState<CreatePlaceSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mapController = MapController();
  final _tempNameController = TextEditingController();
  LatLng? _selectedLocation;
  LatLng? _tempSelectedLocation;
  bool _isLoading = false;
  bool _showMap = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _tempNameController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _createPlace() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location on the map')),
      );
      return;
    }

    // ... inside _createPlace method ...

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to create a place'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final place = Place(
        id: const Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
        status: PlaceStatus.active,

        createdBy: currentUser.id,
        updatedAt: DateTime.now(),
      );

      await ref.read(placesRepositoryProvider).createPlace(place);

      // Refresh places list
      ref.invalidate(myPlacesProvider);

      if (mounted) {
        Navigator.of(context).pop(place);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating place: $e')));
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
    return CustomBottomSheet(
      title: 'Create New Place',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Place Name',
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
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),

                  // Location Selector
                  if (_selectedLocation != null && !_showMap)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Location Selected',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => setState(() {
                              _showMap = true;
                              _tempSelectedLocation = _selectedLocation;
                            }),
                            child: const Text('Change'),
                          ),
                        ],
                      ),
                    )
                  else if (!_showMap)
                    ElevatedButton.icon(
                      onPressed: () => setState(() {
                        _showMap = true;
                        // Trigger logic to center on user if _selectedLocation is null handled in onMapReady
                        _tempSelectedLocation = _selectedLocation;
                      }),
                      icon: const Icon(Icons.map),
                      label: const Text('Pick on Map'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),

                  if (_showMap) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 450,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                initialCenter:
                                    _selectedLocation ??
                                    const LatLng(51.505, -0.09),
                                initialZoom: 13.0,
                                onTap: (tapPosition, point) {
                                  setState(() {
                                    _tempSelectedLocation = point;
                                  });
                                },
                                onMapReady: () {
                                  if (_selectedLocation == null) {
                                    // Optional: Center on user location if not already selected
                                    ref
                                        .read(currentLocationProvider.future)
                                        .then((location) {
                                          if (location != null && mounted) {
                                            _mapController.move(location, 13.0);
                                          }
                                        });
                                  }
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.wysx.app',
                                ),
                                if (_tempSelectedLocation != null)
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: _tempSelectedLocation!,
                                        width: 40,
                                        height: 40,
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            // Search Bar
                            Positioned(
                              top: 16,
                              left: 16,
                              right: 16,
                              child: LocationSearchInput(
                                onPlaceSelected: (place) {
                                  final lat = double.tryParse(
                                    place['lat'].toString(),
                                  );
                                  final lon = double.tryParse(
                                    place['lon'].toString(),
                                  );
                                  if (lat != null && lon != null) {
                                    final point = LatLng(lat, lon);
                                    _mapController.move(point, 15.0);
                                    setState(() {
                                      _tempSelectedLocation = point;
                                      // Update main controller if user confirms later
                                      _tempNameController.text =
                                          place['name'] ?? '';
                                    });
                                  }
                                },
                              ),
                            ),
                            // Cancel Button (Bottom Left)
                            Positioned(
                              bottom: 16,
                              left: 16,
                              child: FloatingActionButton(
                                heroTag: 'cancel_map',
                                onPressed: () => setState(() {
                                  _showMap = false;
                                  _tempSelectedLocation = null;
                                }),
                                backgroundColor: Colors.white,
                                mini: true,
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            // Confirm Button (Bottom Right)
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: FloatingActionButton(
                                heroTag: 'confirm_map',
                                onPressed: () {
                                  if (_tempSelectedLocation != null) {
                                    setState(() {
                                      _selectedLocation = _tempSelectedLocation;
                                      if (_tempNameController.text.isNotEmpty &&
                                          _nameController.text.isEmpty) {
                                        _nameController.text =
                                            _tempNameController.text;
                                      }
                                      _showMap = false;
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please select a location',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                backgroundColor: Colors.black,
                                mini: true,
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createPlace,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Place'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
