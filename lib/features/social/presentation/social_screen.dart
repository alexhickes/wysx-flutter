import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/presentation/widgets/app_header.dart';
import '../../../core/presentation/widgets/custom_bottom_sheet.dart';
import '../../groups/presentation/screens/create_group_screen.dart';
import '../../places/presentation/widgets/create_place_sheet.dart';
import 'tabs/friends_tab.dart';
import 'tabs/groups_tab.dart';
import 'tabs/places_tab.dart';
import 'widgets/user_search_autocomplete.dart';

class SocialScreen extends ConsumerStatefulWidget {
  const SocialScreen({super.key});

  @override
  ConsumerState<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends ConsumerState<SocialScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Social'),
      body: Column(
        children: [
          // Search Bar
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: UserSearchAutocomplete(),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'Friends'),
              Tab(text: 'Groups'),
              Tab(text: 'Places'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [FriendsTab(), GroupsTab(), PlacesTab()],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  Widget? _buildFab(BuildContext context) {
    if (_tabController.index == 0) {
      // Friends Tab
      return FloatingActionButton(
        heroTag: 'social_fab_friends',
        onPressed: () {
          _showAddFriendDialog(context, ref);
        },
        child: const Icon(Icons.person_add),
      );
    } else if (_tabController.index == 1) {
      // Groups Tab
      return FloatingActionButton(
        heroTag: 'social_fab_groups',
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const CustomBottomSheet(
              title: 'Create Group',
              child: CreateGroupForm(),
            ),
          );
        },
        child: const Icon(Icons.group_add),
      );
    } else {
      // Places Tab
      return FloatingActionButton(
        heroTag: 'social_fab_places',
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const CreatePlaceSheet(),
          );
        },
        child: const Icon(Icons.add_location_alt),
      );
    }
  }

  void _showAddFriendDialog(BuildContext context, WidgetRef ref) {
    // TODO: Implement add friend dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add friend feature coming soon!')),
    );
  }
}
