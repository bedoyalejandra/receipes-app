import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/components/custom_text_field.dart';
import 'package:receipes_app_02/components/primary_button.dart';
import 'package:receipes_app_02/constants/custom_colors.dart';
import 'package:receipes_app_02/constants/spacing.dart';
import 'package:receipes_app_02/presentation/screens/auth/signup_screen.dart';
import 'package:receipes_app_02/presentation/wrappers/auth_wrapper.dart';
import 'package:receipes_app_02/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().addListener(_authStateListener);
    });
  }

  void _authStateListener() {
    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();

    if (authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      authProvider.clearError();
    }

    if (authProvider.authStatus == AuthStatus.authenticated &&
        authProvider.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthWrapper()),
        );
      });
    }
  }

  _handleLogin() {
    final authProvider = context.read<AuthProvider>();
    authProvider.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Spacing.padding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello,',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(fontSize: 30),
                        ),
                        SizedBox(height: Spacing.space),
                        Text(
                          'Welcome back!',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 80),

                  CustomTextField(
                    label: 'Email',
                    controller: _emailController,
                    placeholder: 'Enter email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  CustomTextField(
                    label: 'Password',
                    controller: _passwordController,
                    isPassword: true,
                    placeholder: 'Enter password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 50),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          onPressed: () {
                            if (authProvider.authStatus == AuthStatus.loading) {
                              return;
                            }
                            _handleLogin();
                          },
                          title:
                              authProvider.authStatus == AuthStatus.loading
                                  ? 'Loading...'
                                  : 'Sign In',
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        text: 'Don’t have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: CustomColors.secondaryColor),
                          ),
                        ],
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupScreen(),
                                  ),
                                );
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
