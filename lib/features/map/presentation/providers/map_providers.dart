import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/database_provider.dart';
import '../../data/repositories/drift_map_repository.dart';
import '../../domain/repositories/i_map_repository.dart';

final mapRepositoryProvider = Provider<IMapRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftMapRepository(db);
});

final placesProvider = FutureProvider((ref) {
  return ref.watch(mapRepositoryProvider).getPlaces();
});
