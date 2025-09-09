import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/presentation/screens/auth/login_screens.dart';
import 'package:receipes_app_02/presentation/screens/home/home_screen.dart';
import 'package:receipes_app_02/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  void _checkAuthState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final authProvider = context.read<AuthProvider>();
        if (authProvider.authStatus == AuthStatus.authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_splash.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/chef_hat.png'),
                  SizedBox(height: 20),
                  Text(
                    '100K+ Premium Recipe',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 200),
                  Text(
                    'Get Cooking',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 50,
                    ),
                  ),
                  Text(
                    'Simple way to find Tasty Recipe',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
