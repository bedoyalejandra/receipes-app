import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/constants/spacing.dart';
import 'package:receipes_app_02/domain/entities/recipe_step.dart';
import 'package:receipes_app_02/providers/recipe_creation_provider.dart';

class RecipeStepsSection extends StatelessWidget {
  const RecipeStepsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeCreationProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showAddStepDialog(context),
                label: Text('Add Step'),
                icon: Icon(Icons.add),
              ),
            ),
            SizedBox(height: 15),
            if (provider.steps.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.list_alt,
                        size: 50,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No steps added yet',
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
                  itemCount: provider.steps.length,
                  onReorder: (oldIndex, newIndex) {
                    provider.reorderSteps(oldIndex, newIndex);
                  },
                  buildDefaultDragHandles: false,
                  itemBuilder: (context, index) {
                    final step = provider.steps[index];
                    return Card(
                      key: ValueKey(step.id),
                      margin: EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: EdgeInsets.all(Spacing.padding),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${step.stepNumber}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall?.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    step.title,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                PopupMenuButton(
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _showAddStepDialog(context, step: step);
                                    } else {
                                      provider.removeStep(step.id);
                                    }
                                  },
                                  itemBuilder:
                                      (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit),
                                              SizedBox(width: 8),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                ),
                                ReorderableDragStartListener(
                                  index: index,
                                  child: Icon(Icons.drag_handle),
                                ),
                              ],
                            ),
                            if (step.description != null &&
                                step.description!.isNotEmpty) ...[
                              SizedBox(height: 8),
                              Text(
                                step.description!,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
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

  _showAddStepDialog(BuildContext context, {RecipeStep? step}) {
    TextEditingController _titleController = TextEditingController(
      text: step?.title ?? '',
    );
    TextEditingController _descriptionController = TextEditingController(
      text: step?.description ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            step != null ? 'Add Step' : 'Edit step ${step?.stepNumber}',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Step Title',
                  hintText: 'Preheat oven to 350°F',
                ),
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Additional details for this step...',
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_titleController.text.trim().isNotEmpty) {
                  final recipeProvider = context.read<RecipeCreationProvider>();
                  if (step != null) {
                    recipeProvider.updateStep(
                      step.id,
                      _titleController.text.trim(),
                      _descriptionController.text.trim().isNotEmpty
                          ? _descriptionController.text.trim()
                          : null,
                    );
                  } else {
                    recipeProvider.addStep(
                      _titleController.text.trim(),
                      _descriptionController.text.trim().isNotEmpty
                          ? _descriptionController.text.trim()
                          : null,
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child: Text('Add Step'),
            ),
          ],
        );
      },
    );
  }
}
