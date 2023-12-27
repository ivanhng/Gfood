import 'package:flutter/material.dart';
import 'package:gfood_app/components/Menu/menu.dart';

class MenuProvider extends ChangeNotifier {
  Menu _menu = Menu(categories: []);

  Menu get menu => _menu;

  void updateMenu(Menu newMenu) {
    _menu = newMenu;
    notifyListeners();
  }
}
