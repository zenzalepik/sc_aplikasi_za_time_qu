import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/theme_service.dart';
import 'features/home/presentation/pages/home_page.dart';

class DigitalClockApp extends StatelessWidget {
  const DigitalClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      theme: themeService.themeData,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
