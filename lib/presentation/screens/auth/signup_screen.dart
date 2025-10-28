import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/components/custom_text_field.dart';
import 'package:receipes_app_02/components/primary_button.dart';
import 'package:receipes_app_02/constants/custom_colors.dart';
import 'package:receipes_app_02/constants/spacing.dart';
import 'package:receipes_app_02/presentation/screens/auth/login_screens.dart';
import 'package:receipes_app_02/presentation/wrappers/auth_wrapper.dart';
import 'package:receipes_app_02/providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isAcceptedTerms = false;

  final _formKey = GlobalKey<FormState>();

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_isAcceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please accept the terms and conditions'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final authProvider = context.read<AuthProvider>();
      authProvider.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        confirmPassword: _confirmPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Spacing.padding),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Account',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        SizedBox(height: Spacing.space),
                        Text(
                          'Let’s help you set up your account, it won’t take long.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomTextField(
                    label: 'Name',
                    controller: _nameController,
                    placeholder: 'Enter name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  CustomTextField(
                    label: 'Email',
                    controller: _emailController,
                    placeholder: 'Enter email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  CustomTextField(
                    label: 'Password',
                    maxLines: 1,
                    controller: _passwordController,
                    isPassword: true,
                    placeholder: 'Enter password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  CustomTextField(
                    label: 'Confirm Password',
                    maxLines: 1,
                    controller: _confirmPasswordController,
                    isPassword: true,
                    placeholder: 'Retype password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Checkbox(
                        value: _isAcceptedTerms,
                        onChanged: (value) {
                          setState(() {
                            _isAcceptedTerms = value!;
                          });
                        },
                        activeColor: CustomColors.secondaryColor,
                        focusColor: CustomColors.secondaryColor,
                        side: BorderSide(color: CustomColors.secondaryColor),
                      ),
                      Text(
                        'Accept terms & Condition',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: CustomColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          onPressed:
                              authProvider.authStatus == AuthStatus.loading
                                  ? null
                                  : _submitForm,
                          title: authProvider.authStatus == AuthStatus.loading
                              ? 'Loading...'
                              : 'Sign Up',
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        text: 'Already a member? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Sign In',
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
                                    builder: (context) => LoginScreen(),
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
