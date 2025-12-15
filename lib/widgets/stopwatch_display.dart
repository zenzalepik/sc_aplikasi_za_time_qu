import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/time_service.dart';
import '../core/services/theme_service.dart';

class StopwatchDisplay extends StatefulWidget {
  const StopwatchDisplay({super.key});

  @override
  State<StopwatchDisplay> createState() => _StopwatchDisplayState();
}

class _StopwatchDisplayState extends State<StopwatchDisplay> {
  bool _showControls = false;

  String two(int n) => n.toString().padLeft(2, "0");

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _hideControls() {
    setState(() {
      _showControls = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final timeService = Provider.of<TimeService>(context, listen: false);
    final themeService = Provider.of<ThemeService>(context);

    return Consumer<TimeService>(
      builder: (context, ts, child) {
        if (ts.stopwatchElapsed > Duration.zero) {
          final sw = ts.stopwatchElapsed;
          final swText =
              "${two(sw.inHours)}:${two(sw.inMinutes.remainder(60))}:${two(sw.inSeconds.remainder(60))}:${two((sw.inMilliseconds ~/ 10) % 100)}";

          return Column(
            children: [
              Container(
                height: 1,
                color: themeService.primaryColor.withOpacity(0.3),
              ),
              const SizedBox(height: 20),

              // Show title and buttons when controls are visible
              if (_showControls) ...[
                Text(
                  "Stopwatch",
                  style: themeService.getSecondaryTextStyle(
                    color: themeService.primaryColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<TimeService>(
                      builder: (context, ts, child) {
                        final isRunning = ts.stopwatchRunning;
                        final hasElapsed = ts.stopwatchElapsed > Duration.zero;

                        return Row(
                          children: [
                            TextButton(
                              onPressed: isRunning
                                  ? null
                                  : () {
                                      timeService.startStopwatch();
                                      _hideControls();
                                    },
                              child: Text(
                                hasElapsed && !isRunning ? "Resume" : "Start",
                                style: themeService.getSecondaryTextStyle(
                                  color: themeService.primaryColor,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: isRunning
                                  ? () {
                                      timeService.stopStopwatch();
                                      _hideControls();
                                    }
                                  : null,
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
                      onPressed: () {
                        timeService.resetStopwatch();
                        _hideControls();
                      },
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

              // Show stopwatch number (tappable to toggle controls)
              if (!_showControls)
                GestureDetector(
                  onTap: _toggleControls,
                  child: Center(
                    child: Text(
                      swText,
                      style: themeService.getSecondaryTextStyle(
                        fontSize: 24,
                        color: themeService.primaryColor,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
