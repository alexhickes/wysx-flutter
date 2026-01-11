import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/services/nominatim_service.dart';

class LocationSearchInput extends StatefulWidget {
  final Function(Map<String, dynamic>) onPlaceSelected;

  const LocationSearchInput({super.key, required this.onPlaceSelected});

  @override
  State<LocationSearchInput> createState() => _LocationSearchInputState();
}

class _LocationSearchInputState extends State<LocationSearchInput> {
  final _controller = TextEditingController();
  final _nominatimService = NominatimService();
  Timer? _debounce;
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _performSearch(query);
      } else {
        setState(() {
          _results = [];
          _removeOverlay();
        });
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() => _isLoading = true);
    final results = await _nominatimService.searchPlaces(query);
    if (mounted) {
      setState(() {
        _isLoading = false;
        _results = results;
      });
      _showOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surface,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final place = _results[index];
                  final displayName = place['display_name'] ?? 'Unknown';
                  return ListTile(
                    title: Text(
                      displayName.split(',')[0],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () {
                      widget.onPlaceSelected(place);
                      _controller.text = displayName.split(',')[0];
                      _removeOverlay();
                      setState(() => _results = []);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _controller,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search for a place...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    _onSearchChanged('');
                    widget.onPlaceSelected({}); // Clear selection callback
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.grey[800],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
