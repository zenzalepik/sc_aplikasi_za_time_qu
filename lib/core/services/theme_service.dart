import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _prefPrimaryColor = 'primary_color';
  static const String _prefBackgroundColor = 'background_color';

  Color _primaryColor = Colors.greenAccent;
  Color _backgroundColor = Colors.black;

  Color get primaryColor => _primaryColor;
  Color get backgroundColor => _backgroundColor;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final primary = prefs.getInt(_prefPrimaryColor);
    final background = prefs.getInt(_prefBackgroundColor);

    if (primary != null) {
      _primaryColor = Color(primary);
    }
    if (background != null) {
      _backgroundColor = Color(background);
    }
    notifyListeners();
  }

  Future<void> setPrimaryColor(Color color) async {
    _primaryColor = color;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefPrimaryColor, color.value);
  }

  Future<void> setBackgroundColor(Color color) async {
    _backgroundColor = color;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefBackgroundColor, color.value);
  }

  ThemeData get themeData {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: _backgroundColor,
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.dark(
        primary: _primaryColor,
        surface: _backgroundColor,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: _primaryColor, fontSize: 32),
        bodyMedium: TextStyle(color: _primaryColor, fontSize: 22),
        bodySmall: TextStyle(color: _primaryColor, fontSize: 14),
      ),
      // Update other theme properties as needed
      iconTheme: IconThemeData(color: _primaryColor),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: _primaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
