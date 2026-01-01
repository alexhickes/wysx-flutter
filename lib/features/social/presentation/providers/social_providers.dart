import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/friend_request.dart';
import '../../domain/entities/social_user.dart';
import '../../domain/repositories/i_social_repository.dart';
import '../../data/repositories/supabase_social_repository.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

final socialRepositoryProvider = Provider<ISocialRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseSocialRepository(client);
});

final friendsProvider = StreamProvider<List<SocialUser>>((ref) {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getFriends();
});

final incomingRequestsProvider = StreamProvider<List<FriendRequest>>((ref) {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getIncomingRequests();
});

final sentRequestsProvider = StreamProvider<List<FriendRequest>>((ref) {
  final repository = ref.watch(socialRepositoryProvider);
  return repository.getSentRequests();
});

class UserSearchState {
  final bool isLoading;
  final List<SocialUser> results;
  final String? error;

  UserSearchState({
    this.isLoading = false,
    this.results = const [],
    this.error,
  });
}

class UserSearchNotifier extends StateNotifier<UserSearchState> {
  final ISocialRepository _repository;

  UserSearchNotifier(this._repository) : super(UserSearchState());

  Future<void> search(String query) async {
    if (query.length < 2) {
      state = UserSearchState();
      return;
    }

    state = UserSearchState(isLoading: true);
    try {
      final results = await _repository.searchUsers(query);
      state = UserSearchState(results: results);
    } catch (e) {
      state = UserSearchState(error: e.toString());
    }
  }

  void clear() {
    state = UserSearchState();
  }
}

final userSearchProvider =
    StateNotifierProvider<UserSearchNotifier, UserSearchState>((ref) {
      final repository = ref.watch(socialRepositoryProvider);
      return UserSearchNotifier(repository);
    });
