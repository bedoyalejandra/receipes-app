import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/data/repositories/auth_repository_impl.dart';
import 'package:receipes_app_02/data/repositories/navigation_repository_impl.dart';
import 'package:receipes_app_02/data/repositories/user_repository_impl.dart';
import 'package:receipes_app_02/domain/repositories/auth_repository.dart';
import 'package:receipes_app_02/domain/repositories/navigation_repository.dart';
import 'package:receipes_app_02/domain/repositories/user_repository.dart';
import 'package:receipes_app_02/domain/usecases/sign_in_usecase.dart';
import 'package:receipes_app_02/domain/usecases/sign_out_usecase.dart';
import 'package:receipes_app_02/domain/usecases/sign_up_usecase.dart';
import 'package:receipes_app_02/domain/usecases/update_profile_usecase.dart';
import 'package:receipes_app_02/providers/auth_provider.dart' as auth_provider;
import 'package:receipes_app_02/providers/navigation_provider.dart';
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
    final NavigationRepository navigationRepository = NavigationRepositoryImpl();

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
        create: (context) => UserProvider(
          updateProfileUseCase,
          userRepository,
        ),
      ),
    ];
  }
}
