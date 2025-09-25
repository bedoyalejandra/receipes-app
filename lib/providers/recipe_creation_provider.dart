import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receipes_app_02/domain/entities/ingredient.dart';
import 'package:receipes_app_02/domain/entities/measurement_unit.dart';
import 'package:receipes_app_02/domain/entities/receipe_category.dart';
import 'package:receipes_app_02/domain/entities/recipe.dart';
import 'package:receipes_app_02/domain/entities/recipe_ingredient.dart';
import 'package:receipes_app_02/domain/entities/recipe_step.dart';
import 'package:receipes_app_02/domain/usecases/create_recipe_usecase.dart';
import 'package:receipes_app_02/services/firebase_storage_service.dart';
import 'package:receipes_app_02/services/image_picker_service.dart';
import 'package:uuid/uuid.dart';

class RecipeCreationProvider extends ChangeNotifier {
  final CreateRecipeUseCase createRecipeUseCase;
  final FirebaseStorageService firebaseStorageService =
      FirebaseStorageService();
  final Uuid uuid = const Uuid();

  RecipeCreationProvider({required this.createRecipeUseCase});

  String _title = '';
  String _description = '';
  int _cookTime = 30;
  int _servings = 4;
  RecipeCategory _category = RecipeCategory.other;
  String? _imageUrl;
  File? _selectedImage;

  final List<RecipeIngredient> _ingredients = [];
  final List<RecipeStep> _steps = [];

  bool _isLoading = false;
  String? _errorMessage;

  String get title => _title;
  String get description => _description;
  int get cookTime => _cookTime;
  int get servings => _servings;
  RecipeCategory get category => _category;
  String? get imageUrl => _imageUrl;
  File? get selectedImage => _selectedImage;
  List<RecipeIngredient> get ingredients => List.unmodifiable(_ingredients);
  List<RecipeStep> get steps => List.unmodifiable(_steps);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get canSaveRecipe {
    final isTitleValid = _title.isNotEmpty;
    final isDescriptionValid = _description.isNotEmpty;
    final isCookTimeValid = _cookTime > 0;
    final isServingsValid = _servings > 0;
    final isIngredientsValid = _ingredients.isNotEmpty;
    final isStepsValid = _steps.isNotEmpty;
    final isIngredientsQuantityValid = ingredients.every(
      (ingredient) => ingredient.quantity.trim().isNotEmpty,
    );

    final isStepsTitleValid = steps.every(
      (step) => step.title.trim().isNotEmpty,
    );

    return isTitleValid &&
        isDescriptionValid &&
        isCookTimeValid &&
        isServingsValid &&
        isIngredientsValid &&
        isStepsValid &&
        isIngredientsQuantityValid &&
        isStepsTitleValid;
  }

  void setTitle(String title) {
    _title = title;
    _clearError();
    notifyListeners();
  }

  void setDescription(String description) {
    _description = description;
    _clearError();
    notifyListeners();
  }

  void setCookTime(int cookTime) {
    _cookTime = cookTime;
    _clearError();
    notifyListeners();
  }

  void setServings(int servings) {
    _servings = servings;
    _clearError();
    notifyListeners();
  }

  void setCategory(RecipeCategory category) {
    _category = category;
    _clearError();
    notifyListeners();
  }

  void setSelectedImage(File image) {
    _selectedImage = image;
    _clearError();
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source) async {
    final imagePickerService = ImagePickerService();
    final image = await imagePickerService.pickImage(source);
    if (image != null) {
      setSelectedImage(image);
    }
  }

  Future<void> showImagePicker(BuildContext context) async {
    final imagePickerService = ImagePickerService();
    final image = await imagePickerService.showSourceImageDialog(context);
    if (image != null) {
      setSelectedImage(image);
    }
  }

  void removeSelectedImage() {
    _selectedImage = null;
    _imageUrl = null;
    notifyListeners();
  }

  void addIngredient(
    Ingredient ingredient,
    String quantity,
    MeasurementUnit? measurementUnit,
  ) {
    final recipeIngredient = RecipeIngredient(
      id: uuid.v4(),
      ingredient: ingredient,
      quantity: quantity,
      measurementUnit: measurementUnit,
    );
    _ingredients.add(recipeIngredient);
    _clearError();
    notifyListeners();
  }

  void removeIngredient(String id) {
    final index = _ingredients.indexWhere((ingredient) => ingredient.id == id);
    if (index != -1) {
      _ingredients.removeAt(index);
      notifyListeners();
    }
  }

  void updateIngredient(
    String id,
    String quantity,
    MeasurementUnit? measurementUnit,
  ) {
    final index = _ingredients.indexWhere((ingredient) => ingredient.id == id);
    if (index != -1) {
      _ingredients[index] = _ingredients[index].copyWith(
        quantity: quantity,
        measurementUnit: measurementUnit,
      );
      notifyListeners();
    }
  }

  void reorderIngredients(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ingredient = _ingredients.removeAt(oldIndex);
    _ingredients.insert(newIndex, ingredient);
    notifyListeners();
  }

  void addStep(String title, String description) {
    final recipeStep = RecipeStep(
      id: uuid.v4(),
      title: title,
      description: description,
      stepNumber: _steps.length + 1,
    );
    _steps.add(recipeStep);
    _clearError();
    notifyListeners();
  }

  void removeStep(String id) {
    final index = _steps.indexWhere((step) => step.id == id);
    if (index != -1) {
      _steps.removeAt(index);
      notifyListeners();
    }
  }

  void updateStep(String id, String title, String description) {
    final index = _steps.indexWhere((step) => step.id == id);
    if (index != -1) {
      _steps[index] = _steps[index].copyWith(
        title: title,
        description: description,
      );
      notifyListeners();
    }
  }

  void reorderSteps(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final step = _steps.removeAt(oldIndex);
    _steps.insert(newIndex, step);
    notifyListeners();
  }

  Future<void> createRecipe(String userId) async {
    final error = _validateRecipe();
    if (error != null) {
      _errorMessage = error;
      notifyListeners();
      return;
    }

    _setLoading(true);

    try {
      final now = DateTime.now();
      final recipeId = uuid.v4();
      String? finalImageUrl;

      if (_selectedImage != null) {
        try {
          finalImageUrl = await firebaseStorageService.uploadRecipeImage(
            image: _selectedImage!,
            recipeId: recipeId,
            userId: userId,
          );
        } catch (e) {
          print('Error uploading image: $e');
          finalImageUrl = null;
        }
      }

      final recipe = Recipe(
        id: recipeId,
        title: _title,
        description: _description,
        cookingTime: _cookTime,
        servings: _servings,
        category: _category,
        ingredients: _ingredients,
        steps: _steps,
        imageUrl: finalImageUrl,
        userId: userId,
        createdAt: now,
        updatedAt: now,
      );

      await createRecipeUseCase.execute(recipe);
    } catch (e) {
      print('Error creating recipe: $e');
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  String? _validateRecipe() {
    if (_title.isEmpty) {
      return 'Title is required';
    }
    if (_description.isEmpty) {
      return 'Description is required';
    }
    if (_cookTime <= 0) {
      return 'Cook time must be greater than 0';
    }
    if (_servings <= 0) {
      return 'Servings must be greater than 0';
    }
    if (_ingredients.isEmpty) {
      return 'Ingredients are required';
    }
    if (_steps.isEmpty) {
      return 'Steps are required';
    }

    for (int i = 0; i < _ingredients.length; i++) {
      if (_ingredients[i].quantity.isEmpty) {
        return 'Ingredient ${i + 1} quantity is required';
      }
    }

    for (int i = 0; i < _steps.length; i++) {
      if (_steps[i].title.isEmpty) {
        return 'Step ${i + 1} title is required';
      }
    }
    return null;
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
