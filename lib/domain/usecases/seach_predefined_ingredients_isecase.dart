import 'package:receipes_app_02/domain/entities/ingredient.dart';
import 'package:receipes_app_02/domain/repositories/ingredient_repository.dart';

class SearchPredefinedIngredientsUseCase {
  final IngredientRepository ingredientRepository;

  SearchPredefinedIngredientsUseCase({required this.ingredientRepository});

  Future<List<Ingredient>> execute(String query) async {
    if (query.isEmpty) {
      return ingredientRepository.getPredefinedIngredients();
    }
    return ingredientRepository.searchPredefinedIngredients(query.trim());
  }
}