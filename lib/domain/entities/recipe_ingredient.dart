import 'package:receipes_app_02/domain/entities/ingredient.dart';
import 'package:receipes_app_02/domain/entities/measurement_unit.dart';

class RecipeIngredient {
  final String id;
  final Ingredient ingredient;
  final String quantity;
  final MeasurementUnit measurementUnit;

  const RecipeIngredient({
    required this.id,
    required this.ingredient,
    required this.quantity,
    required this.measurementUnit,
  });

  RecipeIngredient copyWith({
    String? id,
    Ingredient? ingredient,
    String? quantity,
    MeasurementUnit? measurementUnit,
  }) {
    return RecipeIngredient(
      id: id ?? this.id,
      ingredient: ingredient ?? this.ingredient,
      quantity: quantity ?? this.quantity,
      measurementUnit: measurementUnit ?? this.measurementUnit,
    );
  }

  toJson() => {
    'id': id,
    'ingredient': ingredient,
    'quantity': quantity,
    'measurementUnit': measurementUnit,
  };

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) => RecipeIngredient(
    id: json['id'],
    ingredient: json['ingredient'],
    quantity: json['quantity'],
    measurementUnit: json['measurementUnit'],
  );

  @override
  String toString() => 'RecipeIngredient(id: $id, ingredient: $ingredient, quantity: $quantity, measurementUnit: $measurementUnit)';
}