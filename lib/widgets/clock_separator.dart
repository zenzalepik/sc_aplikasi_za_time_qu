import 'package:flutter/material.dart';
import '../core/services/theme_service.dart';

/// Widget untuk separator ":" di clock display
/// Menggunakan font size yang sama dengan clock numbers
class ClockSeparator extends StatelessWidget {
  final ThemeService themeService;
  final double? customWidth;
  final bool rotateVertical;

  const ClockSeparator({
    super.key,
    required this.themeService,
    this.customWidth,
    this.rotateVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final separator = Container(
      // color: themeService.primaryColor,
      // width: customWidth ?? 10,
      child: Center(
        child: Text(
          ":",
          textAlign: TextAlign.center,
          style: themeService.getPrimaryTextStyle(
            fontSize: themeService.clockFontSize,
            fontWeight: FontWeight.bold,
            height: 0.9,
            color: themeService.primaryColor,
          ),
        ),
      ),
    );

    if (rotateVertical) {
      // RotatedBox mengubah layout constraints dengan benar
      // quarterTurns: 1 = 90 derajat
      return RotatedBox(quarterTurns: 1, child: separator);
    }

    return separator;
  }
}
