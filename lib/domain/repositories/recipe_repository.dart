import 'package:receipes_app_02/domain/entities/receipe_category.dart';
import 'package:receipes_app_02/domain/entities/recipe.dart';

abstract class RecipeRepository {
  Future<void> createRecipe(Recipe recipe);
  Future<List<Recipe>> getRecipesByUserId(String userId);
  Future<List<Recipe>> getAllRecipes({
    RecipeCategory? category,
    bool sortByDateDec = false,
  });
  Future<Recipe?> getRecipeById(String id);
  Future<void> updateRecipe(Recipe recipe);
  Future<void> deleteRecipe(String id);
  Future<List<Recipe>> searchRecipes(String query, {String? userId});
  Future<List<Recipe>> getRecipesByCategory(
    RecipeCategory category, {
    String? userId,
    bool sortByDateDec = false,
  });
  Future<List<Recipe>> getRecipesByCookingTime(
    int minCookingTimeMinutes,
    int maxCookingTimeMinutes, {
    String? userId,
  });

  Future<List<Recipe>> getRecipesByServings(int servings, {String? userId});
}
