import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../social/presentation/providers/social_providers.dart';
import '../../../groups/presentation/providers/groups_provider.dart';

final notificationsCountProvider = Provider<int>((ref) {
  final friendRequestsAsync = ref.watch(incomingRequestsProvider);
  final groupInvitesAsync = ref.watch(myPendingGroupInvitationsProvider);

  int count = 0;

  friendRequestsAsync.whenData((requests) {
    count += requests.length;
  });

  groupInvitesAsync.whenData((invites) {
    count += invites.length;
  });

  return count;
});
