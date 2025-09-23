import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:receipes_app_02/domain/entities/ingredient.dart';
import 'package:receipes_app_02/domain/repositories/ingredient_repository.dart';

class IngredientRepositoryImpl implements IngredientRepository {
  static const String _ingredientsJsonPath =
      'assets/data/predefined_ingredients.json';
  List<Ingredient>? _cachedIngredients;

  @override
  Future<List<Ingredient>> getPredefinedIngredients() async {
    try {
      final ingredients = await _loadIngredientsFromAssets();
      return ingredients.where((ingredient) => !ingredient.isCustom).toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      throw Exception('Failed to load ingredients from assets');
    }
  }

  @override
  Future<List<Ingredient>> searchPredefinedIngredients(String query) async {
    try {
      if (query.isEmpty) {
        return getPredefinedIngredients();
      }

      final allIngredients = await getPredefinedIngredients();

      return allIngredients
          .where(
            (ingredient) =>
                ingredient.name.toLowerCase().contains(
                  query.toLowerCase().trim(),
                ) ||
                (ingredient.description?.toLowerCase().contains(
                      query.toLowerCase().trim(),
                    ) ??
                    false),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to search ingredients');
    }
  }

  @override
  Future<Ingredient?> getIngredientById(String id) async {
    try {
      final allIngredients = await getPredefinedIngredients();
      return allIngredients.firstWhere((ingredient) => ingredient.id == id);
    } catch (e) {
      throw Exception('Failed to get ingredient by id');
    }
  }

  @override
  Future<void> addIngredient(Ingredient ingredient) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteIngredient(Ingredient ingredient) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateIngredient(Ingredient ingredient) {
    throw UnimplementedError();
  }

  Future<List<Ingredient>> _loadIngredientsFromAssets() async {
    if (_cachedIngredients != null) {
      return _cachedIngredients!;
    }

    try {
      final jsonString = await rootBundle.loadString(_ingredientsJsonPath);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final List<dynamic> ingredientsJson = jsonMap['ingredients'];

      _cachedIngredients =
          ingredientsJson.map((json) => Ingredient.fromJson(json)).toList();

      return _cachedIngredients ?? [];
    } catch (e) {
      throw Exception('Failed to load ingredients from assets');
    }
  }
}
