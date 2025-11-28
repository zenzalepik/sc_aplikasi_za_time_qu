import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class SnackbarHelper {
  static void showSnackbar(
    BuildContext context,
    String message,
    ThemeService themeService,
  ) {
    if (!themeService.useSnackbar) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: themeService.getSecondaryTextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        backgroundColor: themeService.primaryColor.withValues(alpha: 0.9),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
