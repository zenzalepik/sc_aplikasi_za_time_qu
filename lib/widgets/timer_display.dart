import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/time_service.dart';
import '../core/services/theme_service.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key});

  String two(int n) => n.toString().padLeft(2, "0");

  @override
  Widget build(BuildContext context) {
    final timeService = Provider.of<TimeService>(context, listen: false);
    final themeService = Provider.of<ThemeService>(context);

    return Consumer<TimeService>(
      builder: (context, ts, child) {
        if (ts.timerCurrentRemaining > Duration.zero) {
          final timerDuration = ts.timerCurrentRemaining;
          final timerText =
              "${two(timerDuration.inHours)}:${two(timerDuration.inMinutes.remainder(60))}:${two(timerDuration.inSeconds.remainder(60))}:${two((timerDuration.inMilliseconds ~/ 10) % 100)}";

          return Column(
            children: [
              Container(
                height: 1,
                color: themeService.primaryColor.withOpacity(0.3),
              ),
              const SizedBox(height: 20),
              Text(
                "Timer",
                style: themeService.getSecondaryTextStyle(
                  fontSize: 16,
                  color: themeService.primaryColor,
                ),
              ),
              Center(
                child: Text(
                  timerText,
                  style: themeService.getSecondaryTextStyle(
                    fontSize: 50,
                    color: themeService.primaryColor,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<TimeService>(
                    builder: (context, ts, child) {
                      final isRunning = ts.timerRunning;
                      final hasRemaining =
                          ts.timerCurrentRemaining > Duration.zero;
                      final shouldShowResume = hasRemaining && !isRunning;

                      return Row(
                        children: [
                          TextButton(
                            onPressed: isRunning
                                ? null
                                : timeService.startTimer,
                            child: Text(
                              shouldShowResume ? "Resume" : "Start",
                              style: themeService.getSecondaryTextStyle(
                                color: themeService.primaryColor,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: isRunning ? timeService.stopTimer : null,
                            child: Text(
                              "Pause",
                              style: themeService.getSecondaryTextStyle(
                                color: themeService.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  TextButton(
                    onPressed: timeService.resetTimer,
                    child: Text(
                      "Reset",
                      style: themeService.getSecondaryTextStyle(
                        color: themeService.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
