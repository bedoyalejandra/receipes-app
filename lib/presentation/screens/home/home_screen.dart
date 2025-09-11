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
      body: SafeArea(
        child: Column(
          children: [
            Text('Home screen'),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return ElevatedButton(
                  onPressed: () {
                    authProvider.signOut();
                  },
                  child: Text('Sign Out'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
