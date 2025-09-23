import 'package:receipes_app_02/domain/entities/recipe.dart';
import 'package:receipes_app_02/domain/repositories/recipe_repository.dart';

class CreateRecipeUseCase {
  final RecipeRepository recipeRepository;

  CreateRecipeUseCase({required this.recipeRepository});

  Future<void> execute(Recipe recipe) async {
    _validateRecipe(recipe);
    return recipeRepository.createRecipe(recipe);
  }

  _validateRecipe(Recipe recipe) {
    if (recipe.title.isEmpty) {
      throw Exception('Recipe name cannot be empty');
    }
    if (recipe.category == null) {
      throw Exception('Recipe category cannot be null');
    }
    if (recipe.servings <= 0) {
      throw Exception('Recipe servings must be greater than 0');
    }
    if (recipe.cookingTime <= 0) {
      throw Exception('Recipe cooking time must be greater than 0');
    }
    if (recipe.ingredients.isEmpty) {
      throw Exception('Recipe must have at least one ingredient');
    }
    if (recipe.steps.isEmpty) {
      throw Exception('Recipe must have at least one instruction');
    }

    for (var ingredient in recipe.ingredients) {
      if (ingredient.quantity.isEmpty) {
        throw Exception('Recipe ingredient quantity cannot be empty');
      }
      if (ingredient.measurementUnit == null) {
        throw Exception('Recipe ingredient measurement unit cannot be null');
      }
    }

    for (var step in recipe.steps) {
      if (step.title.isEmpty) {
        throw Exception('Recipe step cannot be empty');
      }
    }
  }
}
