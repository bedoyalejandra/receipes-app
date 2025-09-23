import 'package:receipes_app_02/domain/entities/receipe_category.dart';
import 'package:receipes_app_02/domain/entities/recipe.dart';
import 'package:receipes_app_02/domain/repositories/recipe_repository.dart';

class GetAllRecipesUseCase {
  final RecipeRepository recipeRepository;

  GetAllRecipesUseCase({required this.recipeRepository});

  Future<List<Recipe>> execute({
    RecipeCategory? category,
    bool sortByDateDec = false,
  }) async {
    return recipeRepository.getAllRecipes(
      category: category,
      sortByDateDec: sortByDateDec,
    );
  }
}
