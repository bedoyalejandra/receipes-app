import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:receipes_app_02/domain/entities/receipe_category.dart';
import 'package:receipes_app_02/domain/entities/recipe.dart';
import 'package:receipes_app_02/domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final FirebaseFirestore _firestore;
  static const String _recipesCollection = 'recipes';

  RecipeRepositoryImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Future<void> createRecipe(Recipe recipe) async {
    _validateRecipe(recipe);
    try {
      final recipeData = recipe.toJson();
      recipeData['createdAt'] = FieldValue.serverTimestamp();
      recipeData['updatedAt'] = FieldValue.serverTimestamp();

      if (recipe.id.isNotEmpty) {
        await _firestore
            .collection(_recipesCollection)
            .doc(recipe.id)
            .set(recipeData);
      } else {
        await _firestore.collection(_recipesCollection).add(recipeData);
      }
    } catch (e) {
      print('Failed to create recipe: $e');
      throw Exception('Failed to create recipe');
    }
  }

  @override
  Future<List<Recipe>> getRecipesByUserId(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection(_recipesCollection)
              .where('userId', isEqualTo: userId)
              .orderBy('createdAt', descending: true)
              .get();

      return querySnapshot.docs
          .map((doc) => Recipe.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Failed to get recipes by user id: $e');
      throw Exception('Failed to get recipes by user id');
    }
  }

  @override
  Future<Recipe?> getRecipeById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection(_recipesCollection).doc(id).get();

      if (!docSnapshot.exists) {
        return null;
      }

      return Recipe.fromJson({...docSnapshot.data()!, 'id': docSnapshot.id});
    } catch (e) {
      print('Failed to get recipe by id: $e');
      throw Exception('Failed to get recipe by id');
    }
  }

  @override
  Future<void> updateRecipe(Recipe recipe) {
    try {
      final recipeData = recipe.toJson();
      recipeData['updatedAt'] = FieldValue.serverTimestamp();

      return _firestore
          .collection(_recipesCollection)
          .doc(recipe.id)
          .update(recipeData);
    } catch (e) {
      print('Failed to update recipe: $e');
      throw Exception('Failed to update recipe');
    }
  }

  @override
  Future<void> deleteRecipe(String id) {
    try {
      return _firestore.collection(_recipesCollection).doc(id).delete();
    } catch (e) {
      print('Failed to delete recipe: $e');
      throw Exception('Failed to delete recipe');
    }
  }

  @override
  Future<List<Recipe>> getAllRecipes({
    RecipeCategory? category,
    bool sortByDateDec = false,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection(
        _recipesCollection,
      );

      if (category != null) {
        query = query.where('category', isEqualTo: category.name);
      }

      query = query.orderBy('createdAt', descending: sortByDateDec);

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => Recipe.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Failed to get all recipes: $e');
      throw Exception('Failed to get all recipes');
    }
  }

  @override
  Future<List<Recipe>> getRecipesByCategory(
    RecipeCategory category, {
    String? userId,
    bool sortByDateDec = false,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection(_recipesCollection)
          .where('category', isEqualTo: category.name);

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      query = query.orderBy('createdAt', descending: sortByDateDec);

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => Recipe.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Failed to get recipes by category: $e');
      throw Exception('Failed to get recipes by category');
    }
  }

  @override
  Future<List<Recipe>> getRecipesByCookingTime(
    int minCookingTimeMinutes,
    int maxCookingTimeMinutes, {
    String? userId,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection(
        _recipesCollection,
      );

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      query = query
          .where('cookingTime', isGreaterThanOrEqualTo: minCookingTimeMinutes)
          .where('cookingTime', isLessThanOrEqualTo: maxCookingTimeMinutes)
          .orderBy('cookingTime');

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => Recipe.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Failed to get recipes by cooking time: $e');
      throw Exception('Failed to get recipes by cooking time');
    }
  }

  @override
  Future<List<Recipe>> getRecipesByServings(
    int servings, {
    String? userId,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection(
        _recipesCollection,
      );

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      query = query.where('servings', isEqualTo: servings).orderBy('servings');

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => Recipe.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Failed to get recipes by servings: $e');
      throw Exception('Failed to get recipes by servings');
    }
  }

  @override
  Future<List<Recipe>> searchRecipes(String query, {String? userId}) async {
    try {
      Query<Map<String, dynamic>> baseQuery = _firestore.collection(
        _recipesCollection,
      );

      if (userId != null) {
        baseQuery = baseQuery.where('userId', isEqualTo: userId);
      }

      baseQuery = baseQuery
          .orderBy('title')
          .startAt([query.toLowerCase()])
          .endAt([query.toLowerCase() + '\uf8ff']);

      final querySnapshot = await baseQuery.get();

      return querySnapshot.docs
          .map((doc) => Recipe.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Failed to search recipes: $e');
      throw Exception('Failed to search recipes');
    }
  }

  void _validateRecipe(Recipe recipe) {
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
  }
}
