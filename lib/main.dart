import 'package:flutter/material.dart';
import 'app.dart';
import 'package:provider/provider.dart';
import 'core/services/time_service.dart';
import 'core/services/theme_service.dart';
import 'core/services/ui_service.dart';
import 'core/services/stopwatch_history_service.dart';
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

  final stopwatchHistoryService = StopwatchHistoryService();
  await stopwatchHistoryService.init();

  // Connect timeService to auto-save stopwatch to history
  timeService.onStopwatchTick = (date, duration) {
    // Replace today's record with current total (not add)
    stopwatchHistoryService.setDuration(date, duration);
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: timeService),
        ChangeNotifierProvider.value(value: themeService),
        ChangeNotifierProvider.value(value: uiService),
        ChangeNotifierProvider.value(value: stopwatchHistoryService),
      ],
      // Wrap dengan SplashScreen untuk loading indicator
      child: const SplashScreen(child: DigitalClockApp()),
    ),
  );
}
