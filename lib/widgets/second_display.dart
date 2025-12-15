import 'package:flutter/material.dart';
import '../core/services/theme_service.dart';

class SecondDisplay extends StatelessWidget {
  final String secondStr;
  final ThemeService themeService;
  final double bottom;
  final double right;

  const SecondDisplay({
    super.key,
    required this.secondStr,
    required this.themeService,
    this.bottom = 20,
    this.right = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: Text(
        secondStr,
        style: themeService.getPrimaryTextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: themeService.primaryColor.withOpacity(0.5),
        ),
      ),
    );
  }
}
