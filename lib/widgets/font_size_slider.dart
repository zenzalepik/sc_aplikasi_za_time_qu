import 'package:flutter/material.dart';
import '../../../core/services/theme_service.dart';

/// Widget untuk slider font size
class FontSizeSlider extends StatelessWidget {
  final String title;
  final double currentSize;
  final double min;
  final double max;
  final Function(double) onSizeChanged;
  final ThemeService themeService;

  const FontSizeSlider({
    super.key,
    required this.title,
    required this.currentSize,
    required this.min,
    required this.max,
    required this.onSizeChanged,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: themeService.getSecondaryTextStyle(
                color: themeService.primaryColor,
                fontSize: 18,
              ),
            ),
            Text(
              currentSize.toStringAsFixed(0),
              style: themeService.getSecondaryTextStyle(
                color: themeService.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Slider(
          value: currentSize,
          min: min,
          max: max,
          divisions: ((max - min) / 5).round(),
          activeColor: themeService.primaryColor,
          inactiveColor: themeService.primaryColor.withOpacity(0.3),
          onChanged: onSizeChanged,
        ),
      ],
    );
  }
}
