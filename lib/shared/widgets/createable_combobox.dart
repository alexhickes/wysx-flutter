import 'package:flutter/material.dart';

class CreateableCombobox<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final Function(T) onItemSelected;
  final Function(String) onCreate;
  final String hintText;

  const CreateableCombobox({
    super.key,
    required this.items,
    required this.itemLabelBuilder,
    required this.onItemSelected,
    required this.onCreate,
    this.hintText = 'Search or create...',
  });

  @override
  State<CreateableCombobox<T>> createState() => _CreateableComboboxState<T>();
}

class _CreateableComboboxState<T> extends State<CreateableCombobox<T>> {
  final _controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<T> _filteredItems = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        // Delay removal to allow tap event to propagate
        Future.delayed(const Duration(milliseconds: 200), _removeOverlay);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredItems = widget.items
          .where(
            (item) => widget
                .itemLabelBuilder(item)
                .toLowerCase()
                .contains(query.toLowerCase()),
          )
          .toList();
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
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
              constraints: const BoxConstraints(maxHeight: 250),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  ..._filteredItems.map((item) {
                    return ListTile(
                      title: Text(widget.itemLabelBuilder(item)),
                      onTap: () {
                        widget.onItemSelected(item);
                        _controller.text = widget.itemLabelBuilder(item);
                        _focusNode.unfocus();
                      },
                    );
                  }),
                  if (_controller.text.isNotEmpty &&
                      !_filteredItems.any(
                        (item) =>
                            widget.itemLabelBuilder(item).toLowerCase() ==
                            _controller.text.toLowerCase(),
                      ))
                    ListTile(
                      leading: const Icon(Icons.add_circle_outline),
                      title: Text('Create "${_controller.text}"'),
                      textColor: Theme.of(context).colorScheme.primary,
                      iconColor: Theme.of(context).colorScheme.primary,
                      onTap: () {
                        widget.onCreate(_controller.text);
                        _focusNode.unfocus();
                      },
                    ),
                ],
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
        focusNode: _focusNode,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
