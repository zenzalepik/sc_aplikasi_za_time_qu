import 'package:flutter/material.dart';
import 'app.dart';
import 'package:provider/provider.dart';
import 'core/services/time_service.dart';
import 'core/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final timeService = TimeService();
  await timeService.init();

  final themeService = ThemeService();
  await themeService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: timeService),
        ChangeNotifierProvider.value(value: themeService),
      ],
      child: const DigitalClockApp(),
    ),
  );
}
