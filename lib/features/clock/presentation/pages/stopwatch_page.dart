import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/time_service.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/utils/snackbar_helper.dart';

class StopwatchPage extends StatelessWidget {
  const StopwatchPage({super.key});

  String two(int n) => n.toString().padLeft(2, "0");

  @override
  Widget build(BuildContext context) {
    final timeService = Provider.of<TimeService>(context, listen: false);
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Stopwatch".toUpperCase(),
                style: themeService.getSecondaryTextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 40),

              // Use Consumer for the ticking text
              Consumer<TimeService>(
                builder: (context, timeService, child) {
                  final sw = timeService.stopwatchElapsed;
                  final swText =
                      "${two(sw.inHours)}:${two(sw.inMinutes.remainder(60))}:${two(sw.inSeconds.remainder(60))}:${two((sw.inMilliseconds ~/ 10) % 100)}";
                  return Text(
                    swText,
                    style: themeService.getPrimaryTextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),

              // Use Consumer for buttons to access both running state and elapsed time
              Consumer<TimeService>(
                builder: (context, ts, child) {
                  final isRunning = ts.stopwatchRunning;
                  final hasElapsed = ts.stopwatchElapsed > Duration.zero;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            context,
                            label: hasElapsed && !isRunning
                                ? "Resume"
                                : "Start",
                            onPressed: isRunning
                                ? null
                                : () {
                                    timeService.startStopwatch();
                                    SnackbarHelper.showSnackbar(
                                      context,
                                      hasElapsed
                                          ? 'Stopwatch resumed'
                                          : 'Stopwatch started',
                                      themeService,
                                    );
                                  },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            context,
                            label: "Pause",
                            onPressed: isRunning
                                ? () {
                                    timeService.stopStopwatch();
                                    SnackbarHelper.showSnackbar(
                                      context,
                                      'Stopwatch paused',
                                      themeService,
                                    );
                                  }
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            context,
                            label: "Reset",
                            onPressed: () {
                              timeService.resetStopwatch();
                              SnackbarHelper.showSnackbar(
                                context,
                                'Stopwatch reset',
                                themeService,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    VoidCallback? onPressed,
  }) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[900],
        foregroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        label,
        style: themeService.getSecondaryTextStyle(fontSize: 18),
      ),
    );
  }
}
