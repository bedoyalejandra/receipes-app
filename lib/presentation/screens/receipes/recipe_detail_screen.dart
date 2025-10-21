import 'package:flutter/material.dart';
import 'package:receipes_app_02/constants/custom_colors.dart';
import 'package:receipes_app_02/domain/entities/recipe.dart';

class RecipeDetailScreen extends StatefulWidget {
  RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);
  final Recipe recipe;

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Recipe recipe;
  String selectedSection = 'ingredients';

  @override
  void initState() {
    super.initState();
    recipe = widget.recipe;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, size: 24),
              ),
              SizedBox(
                height: 200,
                width: double.infinity,
                child:
                    recipe.imageUrl != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: Stack(
                            children: [
                              Image.network(
                                width: double.infinity,
                                height: 200,
                                recipe.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildDefaultImage(context);
                                },
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '${recipe.cookingTime} min',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        : _buildDefaultImage(context),
              ),
              SizedBox(height: 16),
              Text(
                recipe.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              SizedBox(height: 16),

              if (recipe.description != null) ...[
                Text(
                  recipe.description!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 16),
              ],

              Row(
                children: [
                  Expanded(
                    child: _buildSectionChip(
                      context,
                      label: 'Ingredients',
                      isSelected: selectedSection == 'ingredients',
                      onTap: () {
                        setState(() {
                          selectedSection = 'ingredients';
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildSectionChip(
                      context,
                      label: 'Procedure',
                      isSelected: selectedSection == 'procedure',
                      onTap: () {
                        setState(() {
                          selectedSection = 'procedure';
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${recipe.servings} servings',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    selectedSection == 'ingredients'
                        ? '${recipe.ingredients.length} Items'
                        : '${recipe.steps.length} Steps',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              if (selectedSection == 'ingredients')
                _buildIngredientsList(context, recipe),
              if (selectedSection == 'procedure')
                _buildProcedureList(context, recipe),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildIngredientsList(BuildContext context, Recipe recipe) {
  return Expanded(
    child: ListView.builder(
      itemCount: recipe.ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = recipe.ingredients[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child:
                      ingredient.ingredient.imageUrl != null
                          ? Image.network(
                            ingredient.ingredient.imageUrl!,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.restaurant_menu,
                                size: 30,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              );
                            },
                          )
                          : Icon(
                            Icons.restaurant_menu,
                            size: 30,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                ),
                SizedBox(width: 8),
                Text(
                  ingredient.ingredient.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Text(
                  '${ingredient.quantity} ${ingredient.measurementUnit?.displayName}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildProcedureList(BuildContext context, Recipe recipe) {
  return Expanded(
    child: ListView.builder(
      itemCount: recipe.steps.length,
      itemBuilder: (context, index) {
        final step = recipe.steps[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (step.description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      step.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildSectionChip(
  BuildContext context, {
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? CustomColors.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : CustomColors.primaryColor,
          ),
        ),
      ),
    ),
  );
}

Widget _buildDefaultImage(BuildContext context) {
  return Container(
    height: 200,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      color: Colors.grey.shade200,
    ),
    child: Center(
      child: Icon(
        Icons.restaurant_menu,
        size: 80,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );
}
