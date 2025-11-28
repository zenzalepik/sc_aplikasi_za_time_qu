import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/theme_service.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'package:flutter/services.dart'; // ← Import ini

class DigitalClockApp extends StatefulWidget {
  const DigitalClockApp({super.key});

  @override
  State<DigitalClockApp> createState() => _DigitalClockAppState();
}

class _DigitalClockAppState extends State<DigitalClockApp> {
  @override
  void initState() {
    super.initState();
    // Set full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      theme: themeService.themeData,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
