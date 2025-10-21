import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/constants/spacing.dart';
import 'package:receipes_app_02/presentation/screens/home/widgets/recipe_card.dart';
import 'package:receipes_app_02/providers/auth_provider.dart';
import 'package:receipes_app_02/providers/recipe_display_provider.dart';
import 'package:receipes_app_02/providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
  }

  void _loadUserData() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      context.read<UserProvider>().loadUserData(user);
      context.read<RecipeDisplayProvider>().getUserRecipes(user.id);
    }
  }

  _handleUpdateProfile() {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final userProvider = context.read<UserProvider>();
      final currentUser = authProvider.currentUser;

      if (currentUser != null) {
        userProvider
            .updateProfile(
              user: currentUser,
              newName: _nameController.text,
              newEmail: _emailController.text,
            )
            .then((_) {
              if (userProvider.errorMessage == null) {
                final updatedUser = currentUser.copyWith(
                  name: _nameController.text,
                  email: _emailController.text,
                );
                authProvider.updateCurrentUser(updatedUser);
                setState(() {
                  _isEditing = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Profile updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(userProvider.errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
                userProvider.clearError();
              }
            })
            .catchError((error) {
              print(error);
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, UserProvider>(
      builder: (context, authProvider, userProvider, child) {
        final user = authProvider.currentUser;
        if (user == null) {
          return const Center(child: Text('No user data available'));
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(Spacing.padding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _nameController,
                          enabled: _isEditing,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person),
                            border:
                                _isEditing
                                    ? OutlineInputBorder()
                                    : InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          enabled: _isEditing,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border:
                                _isEditing
                                    ? OutlineInputBorder()
                                    : InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        if (_isEditing) ...[
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = false;
                                      _nameController.text = user.name;
                                      _emailController.text = user.email;
                                    });
                                  },
                                  child: Text('Cancel'),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed:
                                      userProvider.userState ==
                                              UserState.loading
                                          ? null
                                          : _handleUpdateProfile,
                                  child: Text(
                                    userProvider.userState == UserState.loading
                                        ? 'Updating...'
                                        : 'Update',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'My Recipes',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 10),
                _buildRecipeList(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecipeList(BuildContext context) {
    return Consumer<RecipeDisplayProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            if (provider.state == RecipeDisplayState.loading)
              Center(child: CircularProgressIndicator()),
            if (provider.state == RecipeDisplayState.error)
              Center(
                child: Column(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(height: 10),
                    Text(
                      'Something went wrong',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.red),
                    ),
                    SizedBox(height: 10),
                    Text(
                      provider.errorMessage ?? 'Unknown error',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        provider.clearError();
                        provider.getAllRecipes();
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            if (provider.state == RecipeDisplayState.success)
              ...provider.recipes.map((recipe) {
                return RecipeCard(recipe: recipe);
              }),
          ],
        );
      },
    );
  }
}
