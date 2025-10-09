import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:receipes_app_02/domain/entities/receipe_category.dart';
import 'recipe_ingredient.dart';
import 'recipe_step.dart';

class Recipe {
  final String id;
  final String title;
  final String? description;
  final int cookingTime;
  final int servings;
  final RecipeCategory category;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;
  final String? userId; // Owner of the recipe

  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.cookingTime,
    required this.servings,
    required this.category,
    required this.ingredients,
    required this.steps,
    required this.createdAt,
    required this.updatedAt,
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
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageUrl,
    String? userId,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'cookingTime': cookingTime,
      'servings': servings,
      'category': category.toJson(),
      'ingredients': ingredients.map((ingredient) => ingredient.toJson()).toList(),
      'steps': steps.map((step) => step.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      cookingTime: json['cookingTime'] as int,
      servings: json['servings'] as int,
      category: RecipeCategory.fromJson(json['category'] as String),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((ingredient) => RecipeIngredient.fromJson(ingredient as Map<String, dynamic>))
          .toList(),
      steps: (json['steps'] as List<dynamic>)
          .map((step) => RecipeStep.fromJson(step as Map<String, dynamic>))
          .toList(),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      imageUrl: json['imageUrl'] as String?,
      userId: json['userId'] as String?,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.parse(value);
    } else {
      throw ArgumentError('Invalid date format: $value');
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Recipe &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.cookingTime == cookingTime &&
        other.servings == servings &&
        other.category == category &&
        other.ingredients == ingredients &&
        other.steps == steps &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.imageUrl == imageUrl &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      cookingTime,
      servings,
      category,
      ingredients,
      steps,
      createdAt,
      updatedAt,
      imageUrl,
      userId,
    );
  }

  @override
  String toString() {
    return 'Recipe(id: $id, title: $title, description: $description, cookingTime: $cookingTime, servings: $servings, category: $category, ingredients: $ingredients, steps: $steps, createdAt: $createdAt, updatedAt: $updatedAt, imageUrl: $imageUrl, userId: $userId)';
  }
}
