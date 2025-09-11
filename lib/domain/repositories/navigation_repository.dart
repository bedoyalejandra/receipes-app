import 'package:receipes_app_02/domain/entities/nativagation_item.dart';

abstract class NavigationRepository {

  List<NavigationItem> getNavigationItems();

  NavigationItem? getNavigationItemByIndex(int index);

  NavigationItem? getNavigationItemByRoute(String route);

  int getNavigationItemsCount();
} 