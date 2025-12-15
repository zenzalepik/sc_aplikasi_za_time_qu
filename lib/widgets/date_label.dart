import 'package:flutter/material.dart';
import '../core/services/theme_service.dart';

class DateLabel extends StatelessWidget {
  final ThemeService themeService;
  final String dayName;
  final String date;
  final Color currentDayColor;
  final VoidCallback onDayTap;

  const DateLabel({
    super.key,
    required this.themeService,
    required this.dayName,
    required this.date,
    required this.currentDayColor,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Day name with color indicator
        if (themeService.showDay)
          GestureDetector(
            onTap: onDayTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              decoration: BoxDecoration(
                color: currentDayColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: currentDayColor, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentDayColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    dayName,
                    style: themeService.getSecondaryTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: currentDayColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (themeService.showDay && themeService.showDate)
          const SizedBox(width: 12),

        // Conditionally show date
        if (themeService.showDate)
          Center(
            child: Text(
              date,
              style: themeService.getSecondaryTextStyle(
                fontSize: 12,
                color: themeService.primaryColor,
              ),
            ),
          ),
        if (themeService.showDate) const SizedBox(height: 12),
      ],
    );
  }
}
