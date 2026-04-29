import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/entities/recipe.dart';
import '../../data/repositories/recipe_repository.dart';
import 'repository_provider.dart';



final recipeProvider =
    StateNotifierProvider<RecipeNotifier, AsyncValue<List<Recipe>>>((ref) {
  final repo = ref.read(recipeRepositoryProvider);
  return RecipeNotifier(repo);
});

class RecipeNotifier extends StateNotifier<AsyncValue<List<Recipe>>> {
  final RecipeRepository _repo;

  RecipeNotifier(this._repo) : super(const AsyncLoading());

  Future<void> loadByArea(String area) async {
    state = const AsyncLoading();
    try {
      final data = await _repo.getRecipesByArea(area);
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> loadByCategory(String category) async {
    state = const AsyncLoading();
    try {
      final data = await _repo.getRecipesByCategory(category);
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    state = const AsyncLoading();
    try {
      final data = await _repo.searchRecipes(query);
      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void refresh(List<Recipe> updated) {
    if (state is AsyncData) {
      final current = (state as AsyncData<List<Recipe>>).value;
      state = AsyncData(current.map((r) {
        final u = updated.firstWhere((u) => u.id == r.id, orElse: () => r);
        return u;
      }).toList());
    }
  }
}



final contextLoadProvider = FutureProvider<String>((ref) async {
  final locService = ref.read(locationServiceProvider);
  final cuisine = await locService.getCuisineFromLocation();
  ref.read(recipeProvider.notifier).loadByArea(cuisine);
  return cuisine;
});
