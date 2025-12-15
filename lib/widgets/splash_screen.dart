import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/google_fonts_service.dart';
import '../core/services/theme_service.dart';

/// Splash screen yang menampilkan loading saat preload fonts
class SplashScreen extends StatefulWidget {
  final Widget child;

  const SplashScreen({super.key, required this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isReady = false;
  bool _fontsLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Preload Google Fonts
    final success = await GoogleFontsService.preloadFonts();

    setState(() {
      _fontsLoaded = success;
    });

    // Small delay untuk show splash (opsional, bisa dihapus)
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isReady) {
      return widget.child;
    }

    final themeService = Provider.of<ThemeService>(context, listen: false);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: themeService.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Image.asset('assets/logo_app.png', width: 120, height: 120),
              const SizedBox(height: 40),

              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    themeService.primaryColor,
                  ),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 20),

              // Loading text
              Text(
                _fontsLoaded ? 'Almost ready...' : 'Loading fonts...',
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
