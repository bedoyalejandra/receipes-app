import 'package:receipes_app_02/domain/entities/ingredient.dart';
import 'package:receipes_app_02/domain/repositories/ingredient_repository.dart';

class GetPredefinedIngredientsUseCase {
  final IngredientRepository ingredientRepository;

  GetPredefinedIngredientsUseCase({required this.ingredientRepository});

  Future<List<Ingredient>> execute() async {
    return ingredientRepository.getPredefinedIngredients();
  }
}