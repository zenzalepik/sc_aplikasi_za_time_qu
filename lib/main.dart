import 'package:flutter/material.dart';
import 'app.dart';
import 'package:provider/provider.dart';
import 'core/services/time_service.dart';
import 'core/services/theme_service.dart';
import 'core/services/ui_service.dart';
import 'widgets/splash_screen.dart';
import 'package:flutter/services.dart'; // ← Import ini

void main() async {
  // Set full screen sebelum runApp
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  WidgetsFlutterBinding.ensureInitialized();

  final timeService = TimeService();
  await timeService.init();

  final themeService = ThemeService();
  await themeService.init();

  final uiService = UIService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: timeService),
        ChangeNotifierProvider.value(value: themeService),
        ChangeNotifierProvider.value(value: uiService),
      ],
      // Wrap dengan SplashScreen untuk loading indicator
      child: const SplashScreen(child: DigitalClockApp()),
    ),
  );
}
