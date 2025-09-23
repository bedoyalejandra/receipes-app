import 'package:receipes_app_02/domain/entities/receipe_category.dart';
import 'package:receipes_app_02/domain/entities/recipe.dart';
import 'package:receipes_app_02/domain/repositories/recipe_repository.dart';

class GetUserRecipesUseCase {
  final RecipeRepository recipeRepository;

  GetUserRecipesUseCase({required this.recipeRepository});

  Future<List<Recipe>> execute(String userId, {RecipeCategory? category}) async {
    if (category != null) {
      return recipeRepository.getRecipesByCategory(category, userId: userId);
    }
    return recipeRepository.getRecipesByUserId(userId);
  }
}