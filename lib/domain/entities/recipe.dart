import 'package:receipes_app_02/domain/entities/receipe_category.dart';
import 'package:receipes_app_02/domain/entities/recipe_ingredient.dart';
import 'package:receipes_app_02/domain/entities/recipe_step.dart';

class Recipe {
  final String id;
  final String title;
  final String? description;
  final int cookingTime;
  final int servings;
  final RecipeCategory category;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;
  final String? imageUrl;
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Recipe({
    required this.id,
    required this.title,
    required this.cookingTime,
    required this.servings,
    required this.category,
    required this.ingredients,
    required this.steps,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.imageUrl,
    this.userId,
  });

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    int? cookingTime,
    int? servings,
    RecipeCategory? category,
    List<RecipeIngredient>? ingredients,
    List<RecipeStep>? steps,
    String? imageUrl,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      cookingTime: cookingTime ?? this.cookingTime,
      servings: servings ?? this.servings,
      category: category ?? this.category,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      imageUrl: imageUrl ?? this.imageUrl,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'cookingTime': cookingTime,
    'servings': servings,
    'category': category,
    'ingredients': ingredients,
    'steps': steps,
    'imageUrl': imageUrl,
    'userId': userId,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    cookingTime: json['cookingTime'],
    servings: json['servings'],
    category: json['category'],
    ingredients: json['ingredients'],
    steps: json['steps'],
    imageUrl: json['imageUrl'],
    userId: json['userId'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );

  @override
  String toString() =>
      'Recipe(id: $id, title: $title, description: $description, cookingTime: $cookingTime, servings: $servings, category: $category, ingredients: $ingredients, steps: $steps, imageUrl: $imageUrl, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
}
