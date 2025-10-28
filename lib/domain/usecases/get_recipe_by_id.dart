import 'package:receipes_app_02/domain/entities/recipe.dart';
import 'package:receipes_app_02/domain/repositories/recipe_repository.dart';

class GetRecipeByIdUseCase {
  final RecipeRepository recipeRepository;

  GetRecipeByIdUseCase({required this.recipeRepository});

  Future<Recipe?> execute(String recipeId) async {
    return await recipeRepository.getRecipeById(recipeId);
  }
}
