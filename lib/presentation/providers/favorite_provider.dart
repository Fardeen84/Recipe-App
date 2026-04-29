import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/entities/recipe.dart';
import 'repository_provider.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<Recipe>>((ref) {
  return FavoriteNotifier(ref);
});

class FavoriteNotifier extends StateNotifier<List<Recipe>> {
  final Ref _ref;

  FavoriteNotifier(this._ref) : super([]) {
    _load();
  }

  Future<void> _load() async {
    final data = await _ref.read(recipeRepositoryProvider).getFavorites();
    state = data;
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    await _ref.read(recipeRepositoryProvider).toggleFavorite(recipe);
    await _load();
  }

  bool isFavorite(String id) =>
      _ref.read(recipeRepositoryProvider).isFavorite(id);
}
