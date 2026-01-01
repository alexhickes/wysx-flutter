import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/social_user.dart';
import '../providers/social_providers.dart';

class UserSearchAutocomplete extends ConsumerStatefulWidget {
  const UserSearchAutocomplete({super.key});

  @override
  ConsumerState<UserSearchAutocomplete> createState() =>
      _UserSearchAutocompleteState();
}

class _UserSearchAutocompleteState
    extends ConsumerState<UserSearchAutocomplete> {
  Timer? _debounce;
  String _lastQuery = '';
  List<SocialUser> _lastOptions = [];

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<Iterable<SocialUser>> _search(String query) async {
    if (query == _lastQuery) return _lastOptions;

    final repository = ref.read(socialRepositoryProvider);
    try {
      final results = await repository.searchUsers(query);
      // debugPrint('Search results: ${results.length}');
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Found ${results.length} users for "$query"'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      _lastQuery = query;
      _lastOptions = results;
      return results;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Search error: $e')));
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RawAutocomplete<SocialUser>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            final query = textEditingValue.text;
            if (query.length < 2) {
              return const Iterable<SocialUser>.empty();
            }

            // Simple debounce using a completer-like approach isn't straightforward
            // with optionsBuilder's expected return.
            // Instead, we'll just return a future that delays slightly
            // or relies on the repository call.
            // For better UX with RawAutocomplete, we might just let it fire
            // and handle race conditions or use a separate notifier if needed.
            // But let's try direct call first.

            // To properly debounce, we can wrap this in a helper,
            // but RawAutocomplete expects a return value.
            // We'll proceed with direct call for now as the repo is fast enough,
            // or we could use a Debouncer class if we had one.
            return _search(query);
          },
          displayStringForOption: (SocialUser option) => option.username,
          fieldViewBuilder:
              (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: textEditingController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              textEditingController.clear();
                              // Trigger empty options
                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  onChanged: (value) {
                    // Force rebuild to show/hide clear button
                    setState(() {});
                  },
                );
              },
          optionsViewBuilder:
              (
                BuildContext context,
                AutocompleteOnSelected<SocialUser> onSelected,
                Iterable<SocialUser> options,
              ) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Material(
                      elevation: 4.0,
                      color: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: SizedBox(
                        width: constraints.maxWidth,
                        height: 200,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final SocialUser option = options.elementAt(index);
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: option.avatarUrl != null
                                    ? NetworkImage(option.avatarUrl!)
                                    : null,
                                child: option.avatarUrl == null
                                    ? Text(option.username[0].toUpperCase())
                                    : null,
                              ),
                              title: Text(
                                option.displayName ?? option.username,
                              ),
                              subtitle: Text('@${option.username}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.person_add),
                                onPressed: () async {
                                  try {
                                    await ref
                                        .read(socialRepositoryProvider)
                                        .sendFriendRequest(option.username);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Request sent to ${option.username}',
                                          ),
                                        ),
                                      );
                                      // Clear selection/search
                                      onSelected(option);
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    }
                                  }
                                },
                              ),
                              onTap: () {
                                // onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
          onSelected: (SocialUser selection) {
            // Clear the field when an item is "selected" (or added)
            // In this UI, we might want to keep it open or clear it.
            // Let's clear it.
            // The controller is managed by RawAutocomplete, but we can't easily access it here
            // to clear it unless we pass our own controller to fieldViewBuilder.
            // But RawAutocomplete clears it if we return empty string in displayStringForOption? No.

            // Actually, we want to clear the text.
            // We can do that by rebuilding or using a key, but let's leave it for now.
            // The "Add" button handles the action.
          },
        );
      },
    );
  }
}
