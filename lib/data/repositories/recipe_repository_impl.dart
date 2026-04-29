import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';
import '../datasources/local/recipe_local_datasource.dart';
import '../datasources/remote/recipe_remote_datasource.dart';
import '../entities/recipe.dart';
import '../models/recipe_model.dart';
import 'recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remote;
  final RecipeLocalDataSource local;
  final NetworkInfo networkInfo;

  RecipeRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  @override
  Future<List<Recipe>> searchRecipes(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remote.searchRecipes(query);
        if (result.isNotEmpty) await local.cacheRecipes(result);
        return _markFavorites(result);
      } on NetworkException {
        return _markFavorites(await _safeCache());
      } on ServerException {
        rethrow;
      }
    } else {
      return _markFavorites(await _safeCache());
    }
  }

  @override
  Future<List<Recipe>> getRecipesByArea(String area) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remote.getRecipesByArea(area);
        if (result.isNotEmpty) await local.cacheRecipes(result);
        return _markFavorites(result);
      } on NetworkException {
        return _markFavorites(await _safeCache());
      }
    } else {
      return _markFavorites(await _safeCache());
    }
  }

  @override
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remote.getRecipesByCategory(category);
        if (result.isNotEmpty) await local.cacheRecipes(result);
        return _markFavorites(result);
      } on NetworkException {
        return _markFavorites(await _safeCache());
      }
    } else {
      return _markFavorites(await _safeCache());
    }
  }

  @override
  Future<List<Recipe>> getFavorites() => local.getFavorites();

  @override
  Future<void> toggleFavorite(Recipe recipe) {
    // Reconstruct model from entity to preserve all fields
    final Map<String, dynamic> json = {
      'idMeal':          recipe.id,
      'strMeal':         recipe.name,
      'strCategory':     recipe.category,
      'strArea':         recipe.area,
      'strInstructions': recipe.instructions,
      'strMealThumb':    recipe.image,
      'strYoutube':      recipe.youtubeUrl,
      'strTags':         recipe.tags,
    };
    for (int i = 0; i < recipe.ingredients.length; i++) {
      json['strIngredient${i + 1}'] = recipe.ingredients[i].name;
      json['strMeasure${i + 1}']    = recipe.ingredients[i].measure;
    }
    return local.toggleFavorite(RecipeModel.fromJson(json));
  }

  @override
  bool isFavorite(String id) => local.isFavorite(id);



  Future<List<RecipeModel>> _safeCache() async {
    try {
      return await local.getCachedRecipes();
    } on CacheException {
      return <RecipeModel>[];
    }
  }

  List<Recipe> _markFavorites(List<Recipe> recipes) =>
      recipes.map((r) => r.copyWith(isFavorite: local.isFavorite(r.id))).toList();
}
