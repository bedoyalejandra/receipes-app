import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/presentation/screens/navigation/components/custom_bottom_navigation_bar.dart';
import 'package:receipes_app_02/presentation/screens/receipes/create_receipe_screen.dart';
import 'package:receipes_app_02/providers/navigation_provider.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: navigationProvider.currentIndex,
            children:
                navigationProvider.navigationItems
                    .map((item) => item.screen)
                    .toList(),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateReceipeScreen()),
              );
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 28, color: Colors.white),
          ),

          bottomNavigationBar: CustomBottomNavigationBar(),
        );
      },
    );
  }
}
