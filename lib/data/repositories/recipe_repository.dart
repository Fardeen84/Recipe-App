import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> searchRecipes(String query);
  Future<List<Recipe>> getRecipesByArea(String area);
  Future<List<Recipe>> getRecipesByCategory(String category);
  Future<List<Recipe>> getFavorites();
  Future<void> toggleFavorite(Recipe recipe);
  bool isFavorite(String id);
}
