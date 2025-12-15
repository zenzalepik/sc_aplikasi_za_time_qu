import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeService extends ChangeNotifier {
  static const String _prefPrimaryColor = 'primary_color';
  static const String _prefBackgroundColor = 'background_color';
  static const String _prefPrimaryFont = 'primary_font';
  static const String _prefSecondaryFont = 'secondary_font';
  static const String _prefUseSnackbar = 'use_snackbar';
  static const String _prefShowDay = 'show_day';
  static const String _prefShowDate = 'show_date';
  static const String _prefShowStopwatch = 'show_stopwatch';
  static const String _prefShowTimer = 'show_timer';
  static const String _prefCardColor = 'card_color';
  static const String _prefClockFontSize = 'clock_font_size';
  static const String _prefSecondFontSize = 'second_font_size';
  static const String _prefStopwatchFontSize = 'stopwatch_font_size';
  static const String _prefTimerFontSize = 'timer_font_size';

  Color _primaryColor = Colors.greenAccent;
  Color _backgroundColor = Colors.black;
  String _primaryFont = 'Orbitron';
  String _secondaryFont = 'PT Sans';
  bool _useSnackbar = true;
  bool _showDay = true;
  bool _showDate = true;
  bool _showStopwatch = true;
  bool _showTimer = true;
  Color _cardColor = const Color(0xFF1E1E1E);
  double _clockFontSize = 150.0;
  double _secondFontSize = 20.0;
  double _stopwatchFontSize = 24.0;
  double _timerFontSize = 50.0;

  Color get primaryColor => _primaryColor;
  Color get backgroundColor => _backgroundColor;
  String get primaryFont => _primaryFont;
  String get secondaryFont => _secondaryFont;
  bool get useSnackbar => _useSnackbar;
  bool get showDay => _showDay;
  bool get showDate => _showDate;
  bool get showStopwatch => _showStopwatch;
  bool get showTimer => _showTimer;
  Color get cardColor => _cardColor;
  double get clockFontSize => _clockFontSize;
  double get secondFontSize => _secondFontSize;
  double get stopwatchFontSize => _stopwatchFontSize;
  double get timerFontSize => _timerFontSize;

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
    final useSnack = prefs.getBool(_prefUseSnackbar);
    final showD = prefs.getBool(_prefShowDay);
    final showDt = prefs.getBool(_prefShowDate);
    final showSw = prefs.getBool(_prefShowStopwatch);
    final showTm = prefs.getBool(_prefShowTimer);
    final card = prefs.getInt(_prefCardColor);

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
    if (useSnack != null) {
      _useSnackbar = useSnack;
    }
    if (showD != null) {
      _showDay = showD;
    }
    if (showDt != null) {
      _showDate = showDt;
    }
    if (showSw != null) {
      _showStopwatch = showSw;
    }
    if (showTm != null) {
      _showTimer = showTm;
    }
    if (card != null) {
      _cardColor = Color(card);
    }

    // Load font sizes
    final clockSize = prefs.getDouble(_prefClockFontSize);
    final secondSize = prefs.getDouble(_prefSecondFontSize);
    final stopwatchSize = prefs.getDouble(_prefStopwatchFontSize);
    final timerSize = prefs.getDouble(_prefTimerFontSize);

    if (clockSize != null) {
      _clockFontSize = clockSize;
    }
    if (secondSize != null) {
      _secondFontSize = secondSize;
    }
    if (stopwatchSize != null) {
      _stopwatchFontSize = stopwatchSize;
    }
    if (timerSize != null) {
      _timerFontSize = timerSize;
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

  Future<void> setUseSnackbar(bool value) async {
    _useSnackbar = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefUseSnackbar, value);
  }

  Future<void> setShowDay(bool value) async {
    _showDay = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefShowDay, value);
  }

  Future<void> setShowDate(bool value) async {
    _showDate = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefShowDate, value);
  }

  Future<void> setShowStopwatch(bool value) async {
    _showStopwatch = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefShowStopwatch, value);
  }

  Future<void> setShowTimer(bool value) async {
    _showTimer = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefShowTimer, value);
  }

  Future<void> setCardColor(Color color) async {
    _cardColor = color;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefCardColor, color.value);
  }

  Future<void> setClockFontSize(double size) async {
    _clockFontSize = size;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefClockFontSize, size);
  }

  Future<void> setSecondFontSize(double size) async {
    _secondFontSize = size;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefSecondFontSize, size);
  }

  Future<void> setStopwatchFontSize(double size) async {
    _stopwatchFontSize = size;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefStopwatchFontSize, size);
  }

  Future<void> setTimerFontSize(double size) async {
    _timerFontSize = size;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefTimerFontSize, size);
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
