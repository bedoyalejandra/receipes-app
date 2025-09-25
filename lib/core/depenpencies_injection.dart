import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/data/repositories/auth_repository_impl.dart';
import 'package:receipes_app_02/data/repositories/ingredient_repository_impl.dart';
import 'package:receipes_app_02/data/repositories/navigation_repository_impl.dart';
import 'package:receipes_app_02/data/repositories/recipe_repository_impl.dart';
import 'package:receipes_app_02/data/repositories/user_repository_impl.dart';
import 'package:receipes_app_02/domain/repositories/auth_repository.dart';
import 'package:receipes_app_02/domain/repositories/ingredient_repository.dart';
import 'package:receipes_app_02/domain/repositories/navigation_repository.dart';
import 'package:receipes_app_02/domain/repositories/recipe_repository.dart';
import 'package:receipes_app_02/domain/repositories/user_repository.dart';
import 'package:receipes_app_02/domain/usecases/create_recipe_usecase.dart';
import 'package:receipes_app_02/domain/usecases/get_predefined_ingredients_usecase.dart';
import 'package:receipes_app_02/domain/usecases/seach_predefined_ingredients_isecase.dart';
import 'package:receipes_app_02/domain/usecases/sign_in_usecase.dart';
import 'package:receipes_app_02/domain/usecases/sign_out_usecase.dart';
import 'package:receipes_app_02/domain/usecases/sign_up_usecase.dart';
import 'package:receipes_app_02/domain/usecases/update_profile_usecase.dart';
import 'package:receipes_app_02/providers/auth_provider.dart' as auth_provider;
import 'package:receipes_app_02/providers/ingredients_selection_provider.dart';
import 'package:receipes_app_02/providers/navigation_provider.dart';
import 'package:receipes_app_02/providers/recipe_creation_provider.dart';
import 'package:receipes_app_02/providers/theme_provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:receipes_app_02/providers/user_provider.dart';

class DependenciesInjection {
  static List<SingleChildWidget> get providers {
    // Firebase
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    // Repositories
    final AuthRepository authRepository = AuthRepositoryImpl(firebaseAuth);
    final UserRepository userRepository = UserRepositoryImpl(firebaseFirestore);
    final NavigationRepository navigationRepository =
        NavigationRepositoryImpl();
    final RecipeRepository recipeRepository = RecipeRepositoryImpl(
      firestore: firebaseFirestore,
    );
    final IngredientRepository ingredientRepository =
        IngredientRepositoryImpl();

    // UseCases
    final SignInUsecase signInUsecase = SignInUsecase(authRepository);
    final SignUpUsecase signUpUsecase = SignUpUsecase(
      authRepository,
      userRepository,
    );
    final SignOutUsecase signOutUsecase = SignOutUsecase(authRepository);
    final UpdateProfileUseCase updateProfileUseCase = UpdateProfileUseCase(
      userRepository,
    );
    final CreateRecipeUseCase createRecipeUseCase = CreateRecipeUseCase(
      recipeRepository: recipeRepository,
    );
    final GetPredefinedIngredientsUseCase getPredefinedIngredientsUseCase =
        GetPredefinedIngredientsUseCase(
          ingredientRepository: ingredientRepository,
        );
    final SearchPredefinedIngredientsUseCase
    searchPredefinedIngredientsUseCase = SearchPredefinedIngredientsUseCase(
      ingredientRepository: ingredientRepository,
    );

    return [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(
        create:
            (context) => auth_provider.AuthProvider(
              signInUsecase,
              signUpUsecase,
              signOutUsecase,
              authRepository,
              userRepository,
            ),
      ),
      ChangeNotifierProvider(
        create: (context) => NavigationProvider(navigationRepository),
      ),
      ChangeNotifierProvider(
        create: (context) => UserProvider(updateProfileUseCase, userRepository),
      ),
      ChangeNotifierProvider(
        create:
            (context) => RecipeCreationProvider(
              createRecipeUseCase: createRecipeUseCase,
            ),
      ),
      ChangeNotifierProvider(
        create:
            (context) => IngredientsSelectionProvider(
              getPredefinedIngredientsUseCase: getPredefinedIngredientsUseCase,
              searchPredefinedIngredientsUseCase:
                  searchPredefinedIngredientsUseCase,
            ),
      ),
    ];
  }
}
