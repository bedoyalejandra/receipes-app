import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/data/repositories/auth_repository_impl.dart';
import 'package:receipes_app_02/data/repositories/ingredient_repository_impl.dart';
import 'package:receipes_app_02/data/repositories/navigation_repository_impl.dart';
import 'package:receipes_app_02/data/repositories/notifications_repository_impl.dart';
import 'package:receipes_app_02/data/repositories/recipe_repository_impl.dart';
import 'package:receipes_app_02/data/repositories/user_repository_impl.dart';
import 'package:receipes_app_02/domain/repositories/auth_repository.dart';
import 'package:receipes_app_02/domain/repositories/ingredient_repository.dart';
import 'package:receipes_app_02/domain/repositories/navigation_repository.dart';
import 'package:receipes_app_02/domain/repositories/notifications_repository.dart';
import 'package:receipes_app_02/domain/repositories/recipe_repository.dart';
import 'package:receipes_app_02/domain/repositories/user_repository.dart';
import 'package:receipes_app_02/domain/usecases/create_recipe_usecase.dart';
import 'package:receipes_app_02/domain/usecases/get_all_recipes_usecase.dart';
import 'package:receipes_app_02/domain/usecases/get_notifications.dart';
import 'package:receipes_app_02/domain/usecases/get_notifications_stream_usecase.dart';
import 'package:receipes_app_02/domain/usecases/get_predefined_ingredients_usecase.dart';
import 'package:receipes_app_02/domain/usecases/get_recipe_by_id.dart';
import 'package:receipes_app_02/domain/usecases/get_unread_notifications_count_stream.dart';
import 'package:receipes_app_02/domain/usecases/get_user_recipes_usecase.dart';
import 'package:receipes_app_02/domain/usecases/mark_notifications_as_read_usecase.dart';
import 'package:receipes_app_02/domain/usecases/seach_predefined_ingredients_isecase.dart';
import 'package:receipes_app_02/domain/usecases/send_recipe_notification_usecase.dart';
import 'package:receipes_app_02/domain/usecases/sign_in_usecase.dart';
import 'package:receipes_app_02/domain/usecases/sign_out_usecase.dart';
import 'package:receipes_app_02/domain/usecases/sign_up_usecase.dart';
import 'package:receipes_app_02/domain/usecases/update_profile_usecase.dart';
import 'package:receipes_app_02/providers/auth_provider.dart' as auth_provider;
import 'package:receipes_app_02/providers/ingredients_selection_provider.dart';
import 'package:receipes_app_02/providers/navigation_provider.dart';
import 'package:receipes_app_02/providers/notifications_provider.dart';
import 'package:receipes_app_02/providers/recipe_creation_provider.dart';
import 'package:receipes_app_02/providers/recipe_display_provider.dart';
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
    final NotificationsRepository notificationsRepository =
        NotificationsRepositoryImpl(firestore: firebaseFirestore);

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

    final GetAllRecipesUseCase getAllRecipesUseCase = GetAllRecipesUseCase(
      recipeRepository: recipeRepository,
    );
    final GetUserRecipesUseCase getUserRecipesUseCase = GetUserRecipesUseCase(
      recipeRepository: recipeRepository,
    );
    final GetRecipeByIdUseCase getRecipeByIdUseCase = GetRecipeByIdUseCase(
      recipeRepository: recipeRepository,
    );

    final GetNotificationsUseCase getNotificationsUseCase =
        GetNotificationsUseCase(notificationsRepository);
    final GetNotificationsStreamUseCase getNotificationsStreamUseCase =
        GetNotificationsStreamUseCase(notificationsRepository);
    final MarkNotificationsAsReadUseCase markNotificationsAsReadUseCase =
        MarkNotificationsAsReadUseCase(notificationsRepository);
    final GetUnreadNotificationsCountStreamUseCase
    getUnreadNotificationsCountStreamUseCase =
        GetUnreadNotificationsCountStreamUseCase(notificationsRepository);
    SendRecipeNotificationUseCase sendRecipeNotificationUseCase =
        SendRecipeNotificationUseCase(notificationsRepository, userRepository);

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
              sendRecipeNotificationUseCase: sendRecipeNotificationUseCase,
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

      ChangeNotifierProvider(
        create:
            (context) => RecipeDisplayProvider(
              getAllRecipesUseCase: getAllRecipesUseCase,
              getUserRecipesUseCase: getUserRecipesUseCase,
              getRecipeByIdUseCase: getRecipeByIdUseCase,
            ),
      ),
      ChangeNotifierProvider(
        create: (context) => NotificationsProvider(
          getNotificationsUseCase: getNotificationsUseCase,
          getNotificationsStreamUseCase: getNotificationsStreamUseCase,
          markNotificationsAsReadUseCase: markNotificationsAsReadUseCase,
          getUnreadNotificationsCountStreamUseCase:
              getUnreadNotificationsCountStreamUseCase,
        ),
      ),
    ];
  }
}
