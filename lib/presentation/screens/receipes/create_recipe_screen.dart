import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/constants/spacing.dart';
import 'package:receipes_app_02/presentation/screens/receipes/recipe_basic_information_form.dart';
import 'package:receipes_app_02/presentation/screens/receipes/recipe_ingredients_section.dart';
import 'package:receipes_app_02/providers/auth_provider.dart';
import 'package:receipes_app_02/providers/ingredients_selection_provider.dart';
import 'package:receipes_app_02/providers/recipe_creation_provider.dart';

class CreateRecipeScreen extends StatefulWidget {
  CreateRecipeScreen({Key? key}) : super(key: key);

  @override
  _CreateRecipeScreenState createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _totalSteps = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IngredientsSelectionProvider>().loadPredefinedIngredients();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _goToNextPage() {
    if (_currentPage < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _saveRecipe() async {
    final recipeCreationProvider = context.read<RecipeCreationProvider>();
    final authProvider = context.read<AuthProvider>();

    final String? userId = authProvider.currentUser!.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to create a recipe'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await recipeCreationProvider.createRecipe(userId);

    if (recipeCreationProvider.errorMessage == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recipe created successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to create recipe ${recipeCreationProvider.errorMessage}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.padding),
          child: Column(
            children: [
              Text(
                'Create Recipe',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  for (int i = 0; i < _totalSteps; i++) ...[
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color:
                              i <= _currentPage
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade500,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (i < _totalSteps - 1) ...[const SizedBox(width: 8)],
                  ],
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getPageTitle(_currentPage),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    '$_currentPage / $_totalSteps',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    RecipeBasicInformationForm(),
                    RecipeIngredientsSection(),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Consumer<RecipeCreationProvider>(
                  builder: (context, provider, child) {
                    return Row(
                      children: [
                        if (_currentPage > 0) ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _goToPreviousPage,
                              child: const Text('Previous'),
                            ),
                          ),
                          SizedBox(width: 15),
                        ],
                        Expanded(
                          child:
                              _currentPage < _totalSteps - 1
                                  ? ElevatedButton(
                                    onPressed: _goToNextPage,
                                    child: const Text('Next'),
                                  )
                                  : ElevatedButton(
                                    onPressed:
                                        provider.canSaveRecipe &&
                                                !provider.isLoading
                                            ? _saveRecipe
                                            : null,
                                    child: Text(
                                      provider.isLoading
                                          ? 'Saving...'
                                          : 'Save Recipe',
                                    ),
                                  ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_getPageTitle(int index) {
  switch (index) {
    case 0:
      return 'Basic Information';
    case 1:
      return 'Ingredients';
    case 2:
      return 'Preparation Steps';
    default:
      return '';
  }
}
