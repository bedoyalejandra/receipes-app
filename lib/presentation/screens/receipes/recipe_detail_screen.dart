import 'package:flutter/material.dart';
import 'package:receipes_app_02/constants/custom_colors.dart';
import 'package:receipes_app_02/domain/entities/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);
  final Recipe recipe;

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
              Row(
                children: [
                  Expanded(
                    child: _buildSectionChip(
                      context,
                      label: 'Ingredients',
                      isSelected: true,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildSectionChip(
                      context,
                      label: 'Procedure',
                      isSelected: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSectionChip(
  BuildContext context, {
  required String label,
  required bool isSelected,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    decoration: BoxDecoration(
      color:
          isSelected
              ? CustomColors.primaryColor
              : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color:
              isSelected ? Colors.white : CustomColors.primaryColor,
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
