import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/domain/entities/receipe_category.dart';
import 'package:receipes_app_02/presentation/screens/home/widgets/custom_filter_chip.dart';
import 'package:receipes_app_02/providers/auth_provider.dart';
import 'package:receipes_app_02/providers/recipe_display_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeDisplayProvider>().getAllRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (authProvider.currentUser != null)
                              Text(
                                'Hello ${authProvider.currentUser?.name}',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            Text(
                              'What are you cooking today?',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                          ],
                        );
                      },
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.message)),
                  ],
                ),
                SizedBox(height: 20),
                Consumer<RecipeDisplayProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomFilterChip(
                                label: 'All',
                                isSelected: provider.selectedCategory == null,
                                onSelected: (selected) {
                                  if (selected) {
                                    provider.filteeByCategory(null);
                                    provider.getAllRecipes();
                                  }
                                },
                              ),
                              SizedBox(width: 4),
                              ...RecipeCategory.values.map((category) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: CustomFilterChip(
                                    label: category.displayName,
                                    isSelected:
                                        provider.selectedCategory == category,
                                    onSelected: (selected) {
                                      if (selected) {
                                        provider.filteeByCategory(
                                          selected ? category : null,
                                        );
                                        provider.getAllRecipes();
                                      }
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
