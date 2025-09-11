import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipes_app_02/presentation/screens/navigation/components/navigation_icon.dart';
import 'package:receipes_app_02/providers/navigation_provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return BottomAppBar(
          color: Colors.white,
          notchMargin: 10,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavigationIcon(
                iconPath:
                    navigationProvider.currentIndex == 0
                        ? 'assets/icons/house_active.svg'
                        : 'assets/icons/house.svg',
                onTap: () => navigationProvider.navigateToIndex(0),
              ),
              NavigationIcon(
                iconPath:
                    navigationProvider.currentIndex == 1
                        ? 'assets/icons/bookmark_active.svg'
                        : 'assets/icons/bookmark.svg',
                onTap: () => navigationProvider.navigateToIndex(1),
              ),
              SizedBox(width: 40,),
              NavigationIcon(
                iconPath:
                    navigationProvider.currentIndex == 2
                        ? 'assets/icons/notifications_active.svg'
                        : 'assets/icons/notifications.svg',
                onTap: () => navigationProvider.navigateToIndex(2),
              ),
              NavigationIcon(
                iconPath:
                    navigationProvider.currentIndex == 3
                        ? 'assets/icons/profile_active.svg'
                        : 'assets/icons/profile.svg',
                onTap: () => navigationProvider.navigateToIndex(3),
              ),
            ],
          ),
        );
      },
    );
  }
}
