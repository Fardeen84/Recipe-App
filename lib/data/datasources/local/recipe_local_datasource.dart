import 'package:hive/hive.dart';
import '../../../core/error/exceptions.dart';
import '../../models/recipe_model.dart';

abstract class RecipeLocalDataSource {
  Future<void> cacheRecipes(List<RecipeModel> recipes);
  Future<List<RecipeModel>> getCachedRecipes();
  Future<void> toggleFavorite(RecipeModel recipe);
  Future<List<RecipeModel>> getFavorites();
  bool isFavorite(String id);
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  final Box _box;
  static const _cacheKey    = 'cached_recipes';
  static const _favoritesKey = 'favorites';

  RecipeLocalDataSourceImpl(this._box);

  @override
  Future<void> cacheRecipes(List<RecipeModel> recipes) async {
    await _box.put(_cacheKey, recipes.map((r) => r.toJson()).toList());
  }

  @override
  Future<List<RecipeModel>> getCachedRecipes() async {
    final data = _box.get(_cacheKey);
    if (data == null) throw const CacheException('No cached data');
    return (data as List)
        .map((e) => RecipeModel.fromCachedJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<void> toggleFavorite(RecipeModel recipe) async {
    final List raw = _box.get(_favoritesKey, defaultValue: <dynamic>[]) as List;
    final favs = List<Map>.from(raw);

    final exists = favs.any((e) => e['idMeal']?.toString() == recipe.id);
    if (exists) {
      favs.removeWhere((e) => e['idMeal']?.toString() == recipe.id);
    } else {
      favs.add(recipe.withFavorite(true).toJson());
    }

    await _box.put(_favoritesKey, favs);
  }

  @override
  Future<List<RecipeModel>> getFavorites() async {
    final data = _box.get(_favoritesKey, defaultValue: <dynamic>[]) as List;
    return data
        .map((e) => RecipeModel.fromCachedJson(Map<String, dynamic>.from(e as Map)).withFavorite(true))
        .toList();
  }

  @override
  bool isFavorite(String id) {
    final data = _box.get(_favoritesKey, defaultValue: <dynamic>[]) as List;
    return data.any((e) => (e as Map)['idMeal']?.toString() == id);
  }
}
