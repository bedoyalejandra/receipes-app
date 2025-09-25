import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/components/custom_text_field.dart';
import 'package:receipes_app_02/domain/entities/receipe_category.dart';
import 'package:receipes_app_02/providers/recipe_creation_provider.dart';

class RecipeBasicInformationForm extends StatefulWidget {
  RecipeBasicInformationForm({Key? key}) : super(key: key);

  @override
  _RecipeBasicInformationFormState createState() =>
      _RecipeBasicInformationFormState();
}

class _RecipeBasicInformationFormState
    extends State<RecipeBasicInformationForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cookingTimeController = TextEditingController();
  final _servingsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final recipeCreationProvider = context.read<RecipeCreationProvider>();
    _titleController.text = recipeCreationProvider.title;
    _descriptionController.text = recipeCreationProvider.description;
    _cookingTimeController.text = recipeCreationProvider.cookTime.toString();
    _servingsController.text = recipeCreationProvider.servings.toString();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _cookingTimeController.dispose();
    _servingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: _titleController,
            label: 'Receipe Title *',
            placeholder: 'Enter a receipe name',
            onChanged: (value) {
              if (value == null) return;
              context.read<RecipeCreationProvider>().setTitle(value);
            },
          ),
          SizedBox(height: 10),
          CustomTextField(
            controller: _descriptionController,
            label: 'Description *',
            placeholder: 'Enter a description',
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            onChanged: (value) {
              if (value == null) return;
              context.read<RecipeCreationProvider>().setDescription(value);
            },
          ),
          SizedBox(height: 10),

          Consumer<RecipeCreationProvider>(
            builder: (context, provider, child) {
              return DropdownButtonFormField<RecipeCategory>(
                value: provider.category,
                decoration: InputDecoration(
                  labelText: 'Category *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items:
                    RecipeCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.displayName),
                      );
                    }).toList(),
                onChanged: (RecipeCategory? value) {
                  if (value != null) {
                    context.read<RecipeCreationProvider>().setCategory(value);
                  }
                },
              );
            },
          ),

          SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _cookingTimeController,
                  label: 'Cooking Time (min) *',
                  placeholder: '30',
                  prefixIcon: Icon(Icons.timer),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (value == null) return;
                    final minutes = int.tryParse(value) ?? 30;
                    context.read<RecipeCreationProvider>().setCookTime(minutes);
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CustomTextField(
                  controller: _servingsController,
                  label: 'Servings *',
                  placeholder: '4',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (value == null) return;
                    final servings = int.tryParse(value) ?? 4;
                    context.read<RecipeCreationProvider>().setServings(
                      servings,
                    );
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          Consumer<RecipeCreationProvider>(
            builder: (context, provider, child) {
              return Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child:
                    provider.selectedImage != null
                        ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                provider.selectedImage!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: provider.removeSelectedImage,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onPressed:
                                      () => provider.showImagePicker(context),
                                ),
                              ),
                            ),
                          ],
                        )
                        : InkWell(
                          onTap: () => provider.showImagePicker(context),
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  size: 50,
                                  color: Colors.grey.shade400,
                                ),
                                Text(
                                  'Add recipe image',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
              );
            },
          ),
        ],
      ),
    );
  }
}
