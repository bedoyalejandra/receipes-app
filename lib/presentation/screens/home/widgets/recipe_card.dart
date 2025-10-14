import 'package:flutter/material.dart';
import 'package:receipes_app_02/domain/entities/recipe.dart';
import 'package:receipes_app_02/presentation/screens/home/widgets/stat_chip.dart';
import 'package:receipes_app_02/utils/date.dart';
import 'package:receipes_app_02/presentation/screens/receipes/recipe_detail_screen.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({Key? key, required this.recipe, this.onTap})
    : super(key: key);
  final Recipe recipe;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap ?? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              child:
                  recipe.imageUrl != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          recipe.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder(context);
                          },
                        ),
                      )
                      : _buildImagePlaceholder(context),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: Text(
                          recipe.category.displayName,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  if (recipe.description != null &&
                      recipe.description!.isNotEmpty) ...[
                    Text(
                      recipe.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      StatChip(
                        icon: Icons.access_time,
                        label: '${recipe.cookingTime} min',
                      ),
                      SizedBox(width: 8),
                      StatChip(
                        icon: Icons.people,
                        label: '${recipe.servings} servings',
                      ),
                      SizedBox(width: 8),
                      StatChip(
                        icon: Icons.list,
                        label: '${recipe.steps.length} steps',
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Created ${formatDateTime(recipe.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildImagePlaceholder(BuildContext context) {
  return Container(
    height: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      color: Colors.grey.shade200,
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 50,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 8),
          Text(
            'No image',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}
