import 'package:flutter/material.dart';
import 'package:receipes_app_02/domain/entities/ingredient.dart';
import 'package:receipes_app_02/domain/usecases/get_predefined_ingredients_usecase.dart';
import 'package:receipes_app_02/domain/usecases/seach_predefined_ingredients_isecase.dart';

class IngredientsSelectionProvider extends ChangeNotifier {
  final GetPredefinedIngredientsUseCase getPredefinedIngredientsUseCase;
  final SearchPredefinedIngredientsUseCase searchPredefinedIngredientsUseCase;

  IngredientsSelectionProvider({
    required this.getPredefinedIngredientsUseCase,
    required this.searchPredefinedIngredientsUseCase,
  });

  List<Ingredient> _predefinedIngredients = [];
  List<Ingredient> _filteredIngredients = [];
  bool _isLoading = false;
  String? _errorMessage ;
  String _searchQuery = '';

  List<Ingredient> get predefinedIngredients => List.unmodifiable(_predefinedIngredients);
  List<Ingredient> get filteredIngredients => List.unmodifiable(_filteredIngredients);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> loadPredefinedIngredients() async {
    _setLoading(true);

    try {
      _predefinedIngredients = await getPredefinedIngredientsUseCase.execute();
      _filteredIngredients = _predefinedIngredients;
      clearError();
    } catch (e) {
      _errorMessage = 'Failed to load predefined ingredients $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchPredefinedIngredients(String query) async {
    _searchQuery = query;
    
    if(query.trim().isEmpty){
      _filteredIngredients = _predefinedIngredients;
      return;
    }

    _setLoading(true);
    try {
      _filteredIngredients = await searchPredefinedIngredientsUseCase.execute(query.trim());
      clearError();
    } catch (e) {
      _errorMessage = 'Failed to search predefined ingredients $e';
    } finally {
      _setLoading(false);
    }
  }

  Ingredient createCustomIngredient(String name, {String? description}) {
    return Ingredient(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      isCustom: true,
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSearchQuery() {
    _searchQuery = '';
    _filteredIngredients = _predefinedIngredients;
    notifyListeners();
  }
  
}