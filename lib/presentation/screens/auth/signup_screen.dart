import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:receipes_app_02/components/custom_text_field.dart';
import 'package:receipes_app_02/components/primary_button.dart';
import 'package:receipes_app_02/constants/custom_colors.dart';
import 'package:receipes_app_02/constants/spacing.dart';
import 'package:receipes_app_02/presentation/screens/auth/login_screens.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isAcceptedTerms = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                ),
                SizedBox(height: 30),
                CustomTextField(
                  label: 'Email',
                  controller: _emailController,
                  placeholder: 'Enter email',
                ),
                SizedBox(height: 30),
                CustomTextField(
                  label: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                  placeholder: 'Enter password',
                ),
                SizedBox(height: 30),
                CustomTextField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  placeholder: 'Retype password',
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
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(onPressed: () {}, title: 'Sign Up'),
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
    );
  }
}
