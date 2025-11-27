import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeService extends ChangeNotifier {
  static const String _prefPrimaryColor = 'primary_color';
  static const String _prefBackgroundColor = 'background_color';
  static const String _prefPrimaryFont = 'primary_font';
  static const String _prefSecondaryFont = 'secondary_font';

  Color _primaryColor = Colors.greenAccent;
  Color _backgroundColor = Colors.black;
  String _primaryFont = 'Orbitron';
  String _secondaryFont = 'PT Sans';

  Color get primaryColor => _primaryColor;
  Color get backgroundColor => _backgroundColor;
  String get primaryFont => _primaryFont;
  String get secondaryFont => _secondaryFont;

  // Map of available fonts
  static final Map<
    String,
    TextStyle Function({
      TextStyle? textStyle,
      Color? color,
      Color? backgroundColor,
      double? fontSize,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      double? letterSpacing,
      double? wordSpacing,
      TextBaseline? textBaseline,
      double? height,
      Locale? locale,
      Paint? foreground,
      Paint? background,
      List<Shadow>? shadows,
      List<FontFeature>? fontFeatures,
      TextDecoration? decoration,
      Color? decorationColor,
      TextDecorationStyle? decorationStyle,
      double? decorationThickness,
    })
  >
  availableFonts = {
    'Orbitron': GoogleFonts.orbitron,
    'PT Sans': GoogleFonts.ptSans,
    'Roboto': GoogleFonts.roboto,
    'Lato': GoogleFonts.lato,
    'Oswald': GoogleFonts.oswald,
    'Montserrat': GoogleFonts.montserrat,
    'Open Sans': GoogleFonts.openSans,
    'Poppins': GoogleFonts.poppins,
  };

  TextStyle getPrimaryTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    final font = availableFonts[_primaryFont] ?? GoogleFonts.orbitron;
    return font(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  TextStyle getSecondaryTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    final font = availableFonts[_secondaryFont] ?? GoogleFonts.ptSans;
    return font(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final primary = prefs.getInt(_prefPrimaryColor);
    final background = prefs.getInt(_prefBackgroundColor);
    final pFont = prefs.getString(_prefPrimaryFont);
    final sFont = prefs.getString(_prefSecondaryFont);

    if (primary != null) {
      _primaryColor = Color(primary);
    }
    if (background != null) {
      _backgroundColor = Color(background);
    }
    if (pFont != null && availableFonts.containsKey(pFont)) {
      _primaryFont = pFont;
    }
    if (sFont != null && availableFonts.containsKey(sFont)) {
      _secondaryFont = sFont;
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

  Future<void> setPrimaryFont(String fontName) async {
    if (availableFonts.containsKey(fontName)) {
      _primaryFont = fontName;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefPrimaryFont, fontName);
    }
  }

  Future<void> setSecondaryFont(String fontName) async {
    if (availableFonts.containsKey(fontName)) {
      _secondaryFont = fontName;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefSecondaryFont, fontName);
    }
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
        bodyLarge: getSecondaryTextStyle(color: _primaryColor, fontSize: 32),
        bodyMedium: getSecondaryTextStyle(color: _primaryColor, fontSize: 22),
        bodySmall: getSecondaryTextStyle(color: _primaryColor, fontSize: 14),
      ),
      iconTheme: IconThemeData(color: _primaryColor),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          textStyle: getSecondaryTextStyle(),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
          textStyle: getSecondaryTextStyle(),
        ),
      ),
    );
  }
}
