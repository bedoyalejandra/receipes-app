import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receipes_app_02/components/custom_text_field.dart';
import 'package:receipes_app_02/domain/entities/receipe_category.dart';

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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: _titleController,
            label: 'Receipe Title *',
            placeholder: 'Enter a receipe name',
          ),
          SizedBox(height: 10),
          CustomTextField(
            controller: _descriptionController,
            label: 'Description *',
            placeholder: 'Enter a description',
            keyboardType: TextInputType.multiline,
            maxLines: 4,
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<RecipeCategory>(
            items: RecipeCategory.values.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.displayName),
              );
            }).toList(),
            onChanged: (value) {},
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
