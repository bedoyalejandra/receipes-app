import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/domain/entities/measurement_unit.dart';
import 'package:receipes_app_02/providers/ingredients_selection_provider.dart';
import 'package:receipes_app_02/providers/recipe_creation_provider.dart';

class CustomIngredientDialog extends StatefulWidget {
  CustomIngredientDialog({Key? key}) : super(key: key);

  @override
  _CustomIngredientDialogState createState() => _CustomIngredientDialogState();
}

class _CustomIngredientDialogState extends State<CustomIngredientDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  MeasurementUnit? _selectedMeasurementUnit;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Add Custom Ingredient',
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
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Ingredient Name',
                hintText: 'e,g. Tomato',
                prefixIcon: Icon(Icons.restaurant),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Ingredient Description',
                hintText: 'Brief description of the ingredient',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Custom Ingredients are only saved to this recipe and won\'t appear in the general ingredient library',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
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
                    child: Text('Add Ingredient', textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _canAddIngredient() {
    if (_nameController.text.trim().isEmpty ||
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
    final customIngrent = context
        .read<IngredientsSelectionProvider>()
        .createCustomIngredient(
          _nameController.text.trim(),
          description:
              _descriptionController.text.trim().isNotEmpty
                  ? _descriptionController.text.trim()
                  : null,
        );

    context.read<RecipeCreationProvider>().addIngredient(
      customIngrent,
      _quantityController.text.trim(),
      _selectedMeasurementUnit,
    );

    Navigator.of(context).pop();
  }
}
