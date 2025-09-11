import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                            ),
                          ],
                        );
                      },
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.message)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
