import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                    onPressed: () => _showCustomIngredientsSectionDialog(context),
                    label: Text('Add Custom'),
                  ),
                ),
              ],
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
}
