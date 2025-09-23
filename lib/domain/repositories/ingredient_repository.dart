import 'package:receipes_app_02/domain/entities/ingredient.dart';

abstract class IngredientRepository {
  Future<List<Ingredient>> getPredefinedIngredients();

  Future<List<Ingredient>> searchPredefinedIngredients(String query);

  Future<Ingredient?> getIngredientById(String id);

  Future<void> addIngredient(Ingredient ingredient);

  Future<void> deleteIngredient(Ingredient ingredient);

  Future<void> updateIngredient(Ingredient ingredient);

}
