import 'package:flutter/material.dart';
import 'package:receipes_app_02/domain/entities/nativagation_item.dart';
import 'package:receipes_app_02/domain/repositories/navigation_repository.dart';

class NavigationProvider extends ChangeNotifier {
  final NavigationRepository _navigationRepository;
  int _currentIndex = 0;

  NavigationProvider(this._navigationRepository);

  int get currentIndex => _currentIndex;

  List<NavigationItem> get navigationItems => _navigationRepository.getNavigationItems();

  NavigationItem? get currentItem => navigationItems[_currentIndex];

  Widget get currentScreen => currentItem?.screen ?? const SizedBox.shrink();

  void navigateToIndex(int index) {
    if(index >= 0 && index < navigationItems.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  int get navigationItemsCount => navigationItems.length;
}