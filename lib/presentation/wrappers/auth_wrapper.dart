import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/presentation/screens/auth/login_screens.dart';
import 'package:receipes_app_02/presentation/screens/home/home_screen.dart';
import 'package:receipes_app_02/presentation/screens/splash_screen.dart';
import 'package:receipes_app_02/providers/auth_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        Widget targetScreen;
        switch (authProvider.authStatus) {
          case AuthStatus.initial:
          case AuthStatus.loading:
            targetScreen = SplashScreen();
            break;

          case AuthStatus.authenticated:
            targetScreen = HomeScreen();
            break;

          case AuthStatus.unauthenticated:
          case AuthStatus.error:
            targetScreen = LoginScreen();
            break;
        }

        return targetScreen;
      },
    );
  }
}
