import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/domain/entities/measurement_unit.dart';
import 'package:receipes_app_02/domain/entities/recipe_ingredient.dart';
import 'package:receipes_app_02/presentation/screens/receipes/widgets/custom_ingredient_dialog.dart';
import 'package:receipes_app_02/presentation/screens/receipes/widgets/ingredient_selection_dialog.dart';
import 'package:receipes_app_02/providers/recipe_creation_provider.dart';

class RecipeIngredientsSection extends StatelessWidget {
  const RecipeIngredientsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeCreationProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.search),
                    onPressed: () => _showIngredientsSectionDialog(context),
                    label: Text('Add from library'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    onPressed:
                        () => _showCustomIngredientsSectionDialog(context),
                    label: Text('Add Custom'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            if (provider.ingredients.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: 50,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No ingredients selected yet',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ReorderableListView.builder(
                  itemCount: provider.ingredients.length,
                  onReorder: (oldIndex, newIndex) {
                    provider.reorderIngredients(oldIndex, newIndex);
                  },
                  itemBuilder: (context, index) {
                    final ingredient = provider.ingredients[index];
                    return Card(
                      key: ValueKey(ingredient.id),
                      margin: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              ingredient.ingredient.isCustom
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.secondaryContainer
                                  : Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                          child: Icon(
                            ingredient.ingredient.isCustom
                                ? Icons.edit
                                : Icons.inventory_2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        title: Text(ingredient.ingredient.name),
                        subtitle: Text(
                          '${ingredient.quantity} ${ingredient.measurementUnit}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed:
                                  () => _showEditIngredientDialog(
                                    context,
                                    ingredient,
                                  ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).colorScheme.error,
                              onPressed:
                                  () =>
                                      provider.removeIngredient(ingredient.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  _showIngredientsSectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => IngredientSelectionDialog(),
    );
  }

  _showCustomIngredientsSectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomIngredientDialog(),
    );
  }

  _showEditIngredientDialog(BuildContext context, RecipeIngredient ingredient) {
    TextEditingController _quantityController = TextEditingController(
      text: ingredient.quantity,
    );
    MeasurementUnit? _selectedMeasurementUnit = ingredient.measurementUnit;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Edit ${ingredient.ingredient.name}'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        hintText: '1, 2, 500',
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<MeasurementUnit>(
                      value: _selectedMeasurementUnit,
                      decoration: InputDecoration(labelText: 'Unit'),
                      items:
                          MeasurementUnit.values.map((unit) {
                            return DropdownMenuItem(
                              value: unit,
                              child: Text(unit.displayName),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMeasurementUnit = value;
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_quantityController.text.trim().isNotEmpty &&
                          _selectedMeasurementUnit != null) {
                        context.read<RecipeCreationProvider>().updateIngredient(
                          ingredient.id,
                          _quantityController.text.trim(),
                          _selectedMeasurementUnit,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Update'),
                  ),
                ],
              );
            },
          ),
    );
  }
}
