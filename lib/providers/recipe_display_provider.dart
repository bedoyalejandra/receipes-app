import 'package:flutter/material.dart';
import 'package:receipes_app_02/domain/entities/receipe_category.dart';
import 'package:receipes_app_02/domain/entities/recipe.dart';
import 'package:receipes_app_02/domain/usecases/get_all_recipes_usecase.dart';
import 'package:receipes_app_02/domain/usecases/get_user_recipes_usecase.dart';

enum RecipeDisplayState { initial, loading, success, error }

class RecipeDisplayProvider extends ChangeNotifier {
  final GetAllRecipesUseCase _getAllRecipesUseCase;
  final GetUserRecipesUseCase _getUserRecipesUseCase;

  RecipeDisplayProvider({
    required GetAllRecipesUseCase getAllRecipesUseCase,
    required GetUserRecipesUseCase getUserRecipesUseCase,
  }) : _getAllRecipesUseCase = getAllRecipesUseCase,
       _getUserRecipesUseCase = getUserRecipesUseCase;

  RecipeDisplayState _state = RecipeDisplayState.initial;
  List<Recipe> _recipes = [];
  String? _errorMessage;
  RecipeCategory? _selectedCategory;
  bool _sortByDateDescending = false;

  RecipeDisplayState get state => _state;
  List<Recipe> get recipes => List.unmodifiable(_recipes);
  String? get errorMessage => _errorMessage;
  RecipeCategory? get selectedCategory => _selectedCategory;
  bool get sortByDateDescending => _sortByDateDescending;

  Future<void> getAllRecipes() async {
    _setState(RecipeDisplayState.loading);
    try {
      _recipes = await _getAllRecipesUseCase.execute(
        category: _selectedCategory,
        sortByDateDec: _sortByDateDescending,
      );
      _setState(RecipeDisplayState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(RecipeDisplayState.error);
    }
  }

  Future<void> getUserRecipes(String userId) async {
    _setState(RecipeDisplayState.loading);
    try {
      _recipes = await _getUserRecipesUseCase.execute(
        userId,
        category: _selectedCategory,
      );
      _setState(RecipeDisplayState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(RecipeDisplayState.error);
    }
  }

  void filteeByCategory(RecipeCategory category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void toggleSortByDateDescending() {
    _sortByDateDescending = !_sortByDateDescending;
    notifyListeners();
  }


  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void resetFilters() {
    _selectedCategory = null;
    _sortByDateDescending = false;
    notifyListeners();
  }

  _setState(RecipeDisplayState state) {
    _state = state;
    notifyListeners();
  }
}
