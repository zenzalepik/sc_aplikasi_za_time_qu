import 'package:flutter/material.dart';

class UIService extends ChangeNotifier {
  bool _isNavbarVisible = true;

  bool get isNavbarVisible => _isNavbarVisible;

  void toggleNavbar() {
    _isNavbarVisible = !_isNavbarVisible;
    notifyListeners();
  }

  void showNavbar() {
    if (!_isNavbarVisible) {
      _isNavbarVisible = true;
      notifyListeners();
    }
  }

  void hideNavbar() {
    if (_isNavbarVisible) {
      _isNavbarVisible = false;
      notifyListeners();
    }
  }
}
