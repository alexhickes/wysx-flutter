import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:latlong2/latlong.dart';
import 'package:wysx/shared/widgets/location_search_input.dart';
import '../../domain/entities/place.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/places_provider.dart';

class CreatePlaceScreen extends ConsumerStatefulWidget {
  const CreatePlaceScreen({super.key});

  @override
  ConsumerState<CreatePlaceScreen> createState() => _CreatePlaceScreenState();
}

class _CreatePlaceScreenState extends ConsumerState<CreatePlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isPublic = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _createPlace() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Mock location for now - using FutureProvider properly
      final locationValue = await ref.read(currentLocationProvider.future);
      final location = locationValue ?? const LatLng(0, 0);
      final user = ref.read(currentUserProvider);

      if (user == null) {
        throw Exception('User must be logged in to create a place');
      }

      final place = Place(
        id: const Uuid().v4(),
        name: _nameController.text,
        latitude: location.latitude,
        longitude: location.longitude,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        address: _addressController.text.isEmpty
            ? null
            : _addressController.text,
        isPublic: _isPublic,
        createdBy: user.id,
        updatedAt: DateTime.now(),
        syncStatus: 'created',
      );

      await ref.read(placesRepositoryProvider).createPlace(place);

      // Refresh the list
      ref.invalidate(nearbyPlacesProvider);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Place created successfully')),
        );
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
    return Scaffold(
      appBar: AppBar(title: const Text('Add Place')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            LocationSearchInput(
              onPlaceSelected: (place) {
                final lat = double.tryParse(place['lat'].toString());
                final lon = double.tryParse(place['lon'].toString());
                if (lat != null && lon != null) {
                  // _mapController.move(LatLng(lat, lon), 15.0);
                }
              },
            ),
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
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Public Place'),
              subtitle: const Text('Anyone can see this place'),
              value: _isPublic,
              onChanged: (value) {
                setState(() {
                  _isPublic = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _createPlace,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Create Place'),
            ),
          ],
        ),
      ),
    );
  }
}
