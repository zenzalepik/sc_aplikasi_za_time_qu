import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.greenAccent, fontSize: 32),
      bodyMedium: TextStyle(color: Colors.greenAccent, fontSize: 22),
      bodySmall: TextStyle(color: Colors.greenAccent, fontSize: 14),
    ),
  );
}
