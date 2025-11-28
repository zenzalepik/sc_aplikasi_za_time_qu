import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/time_service.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/utils/snackbar_helper.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

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
                "Timer".toUpperCase(),
                style: themeService.getSecondaryTextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 40),

              // Use Consumer for ticking text
              Consumer<TimeService>(
                builder: (context, timeService, child) {
                  final duration = timeService.timerCurrentRemaining;
                  final timerText =
                      "${two(duration.inMinutes)}:${two(duration.inSeconds % 60)}";
                  return Text(
                    timerText,
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
                selector: (_, service) => service.timerRunning,
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
                                    timeService.startTimer();
                                    SnackbarHelper.showSnackbar(
                                      context,
                                      'Timer started',
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
                            label: "Pause",
                            onPressed: isRunning
                                ? () {
                                    timeService.stopTimer();
                                    SnackbarHelper.showSnackbar(
                                      context,
                                      'Timer paused',
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
                              timeService.resetTimer();
                              SnackbarHelper.showSnackbar(
                                context,
                                'Timer reset',
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
              const SizedBox(height: 40),

              // Use Selector for duration picker visibility
              Selector<TimeService, bool>(
                selector: (_, service) => service.timerRunning,
                builder: (context, isRunning, child) {
                  if (!isRunning) {
                    return _buildDurationPicker(context, timeService);
                  }
                  return const SizedBox.shrink();
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

  Widget _buildDurationPicker(BuildContext context, TimeService timeService) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeButton(
          context,
          "1 Min",
          const Duration(minutes: 1),
          timeService,
        ),
        const SizedBox(width: 10),
        _buildTimeButton(
          context,
          "5 Min",
          const Duration(minutes: 5),
          timeService,
        ),
        const SizedBox(width: 10),
        _buildTimeButton(
          context,
          "10 Min",
          const Duration(minutes: 10),
          timeService,
        ),
      ],
    );
  }

  Widget _buildTimeButton(
    BuildContext context,
    String label,
    Duration duration,
    TimeService timeService,
  ) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    return TextButton(
      onPressed: () => timeService.setTimerDuration(duration),
      child: Text(
        label,
        style: themeService.getSecondaryTextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
