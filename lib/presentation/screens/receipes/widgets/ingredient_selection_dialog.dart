import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/constants/spacing.dart';
import 'package:receipes_app_02/domain/entities/ingredient.dart';
import 'package:receipes_app_02/domain/entities/measurement_unit.dart';
import 'package:receipes_app_02/providers/ingredients_selection_provider.dart';
import 'package:receipes_app_02/providers/recipe_creation_provider.dart';

class IngredientSelectionDialog extends StatefulWidget {
  IngredientSelectionDialog({Key? key}) : super(key: key);

  @override
  _IngredientSelectionDialogState createState() =>
      _IngredientSelectionDialogState();
}

class _IngredientSelectionDialogState extends State<IngredientSelectionDialog> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  Ingredient? _selectedIngredient;
  MeasurementUnit? _selectedMeasurementUnit;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(Spacing.padding),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Select Ingredient',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search ingredient',
                hintText: 'Type to search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                context
                    .read<IngredientsSelectionProvider>()
                    .searchPredefinedIngredients(value);
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: Consumer<IngredientsSelectionProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (provider.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 45,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.predefinedIngredients.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 45,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          SizedBox(height: 16),
                          Text('No Ingredients Found'),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: provider.filteredIngredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = provider.filteredIngredients[index];
                      final isSelected =
                          _selectedIngredient?.id == ingredient.id;
                      return Card(
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                            child:
                                ingredient.imageUrl != null
                                    ? Image.network(
                                      ingredient.imageUrl!,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Icon(
                                          Icons.restaurant,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        );
                                      },
                                    )
                                    : Icon(
                                      Icons.restaurant,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                          ),
                          title: Text(ingredient.name),
                          subtitle:
                              ingredient.description != null
                                  ? Text(
                                    ingredient.description!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                  : null,
                          trailing:
                              isSelected
                                  ? Icon(Icons.check, color: Colors.white)
                                  : null,
                          onTap: () {
                            setState(() {
                              _selectedIngredient = ingredient;
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            if (_selectedIngredient != null) ...[
              Text(
                'Add ${_selectedIngredient!.name}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        hintText: '1, 2, 500',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<MeasurementUnit>(
                      value: _selectedMeasurementUnit,
                      decoration: InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      isExpanded: true,
                      items:
                          MeasurementUnit.values.map((unit) {
                            return DropdownMenuItem<MeasurementUnit>(
                              value: unit,
                              child: Text(
                                unit.displayName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMeasurementUnit = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _canAddIngredient() ? _addIngredient : null,
                      child: Text(
                        'Add Ingredient',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  _canAddIngredient() {
    if (_selectedIngredient == null ||
        _quantityController.text.trim().isEmpty ||
        _selectedMeasurementUnit == null) {
      return false;
    }
    if (double.tryParse(_quantityController.text.trim()) == null) {
      return false;
    }
    return true;
  }

  _addIngredient() {
    context.read<RecipeCreationProvider>().addIngredient(
      _selectedIngredient!,
      _quantityController.text.trim(),
      _selectedMeasurementUnit!,
    );
    Navigator.of(context).pop();
  }
}
