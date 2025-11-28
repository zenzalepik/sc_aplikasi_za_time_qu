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
                      "${two(sw.inMinutes)}:${two(sw.inSeconds % 60)}:${two((sw.inMilliseconds ~/ 10) % 100)}";
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

              // Use Selector for buttons
              Selector<TimeService, bool>(
                selector: (_, service) => service.stopwatchRunning,
                builder: (context, isRunning, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          // ← Tambahkan ini
                          child: _buildButton(
                            context,
                            label: "Start",
                            onPressed: isRunning
                                ? null
                                : () {
                                    timeService.startStopwatch();
                                    SnackbarHelper.showSnackbar(
                                      context,
                                      'Stopwatch started',
                                      themeService,
                                    );
                                  },
                          ),
                        ),
                        const SizedBox(width: 8), // Kurangi spacing
                        Expanded(
                          // ← Tambahkan ini
                          child: _buildButton(
                            context,
                            label: "Stop",
                            onPressed: isRunning
                                ? () {
                                    timeService.stopStopwatch();
                                    SnackbarHelper.showSnackbar(
                                      context,
                                      'Stopwatch stopped',
                                      themeService,
                                    );
                                  }
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8), // Kurangi spacing
                        Expanded(
                          // ← Tambahkan ini
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
