import 'package:flutter/material.dart';
import 'package:receipes_app_02/domain/entities/nativagation_item.dart';
import 'package:receipes_app_02/domain/repositories/navigation_repository.dart';
import 'package:receipes_app_02/presentation/screens/home/home_screen.dart';
import 'package:receipes_app_02/presentation/screens/notifications/notification_screen.dart';
import 'package:receipes_app_02/presentation/screens/profile/profile_screen.dart';
import 'package:receipes_app_02/presentation/screens/saved/saved_screen.dart';

class NavigationRepositoryImpl implements NavigationRepository {

  static final List<NavigationItem> _navigationItems = [
    NavigationItem.create(
      label: 'Home',
      icon: Icons.home,
      screen: HomeScreen(),
      route: '/home'
    ),
    NavigationItem.create(
      label: 'Saved',
      icon: Icons.bookmark,
      screen: SavedScreen(),
      route: '/saved',
    ),
    NavigationItem.create(
      label: 'Notification',
      icon: Icons.notifications,
      screen: NotificationScreen(),
      route: '/notification',
    ),
    NavigationItem.create(
      label: 'Profile',
      icon: Icons.person,
      screen: ProfileScreen(),
      route: '/profile',
    ),
  ];

  @override
  NavigationItem? getNavigationItemByIndex(int index) {
    if(index > 0 && index < _navigationItems.length) {
      return _navigationItems[index];
    }
    return null;
  }

  @override
  NavigationItem? getNavigationItemByRoute(String route) {
    return _navigationItems.firstWhere((element) => element.route == route);
  }

  @override
  List<NavigationItem> getNavigationItems() {
    return _navigationItems;
  }

  @override
  int getNavigationItemsCount() {
    return _navigationItems.length;
  }
  
}