import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/time_service.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/utils/snackbar_helper.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool _showUI = true;

  void _toggleUI() {
    setState(() {
      _showUI = !_showUI;
    });
  }

  String two(int n) => n.toString().padLeft(2, "0");

  @override
  Widget build(BuildContext context) {
    final timeService = Provider.of<TimeService>(context, listen: false);
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _showUI ? AppBar(backgroundColor: Colors.transparent) : null,
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
                      "${two(duration.inHours)}:${two(duration.inMinutes.remainder(60))}:${two(duration.inSeconds.remainder(60))}:${two((duration.inMilliseconds ~/ 10) % 100)}";
                  return GestureDetector(
                    onTap: _toggleUI,
                    child: Text(
                      timerText,
                      style: themeService.getPrimaryTextStyle(
                        fontSize: themeService.timerPageFontSize,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),

              // Use Consumer for buttons to access both running state and remaining time
              Consumer<TimeService>(
                builder: (context, ts, child) {
                  final isRunning = ts.timerRunning;
                  final hasRemaining = ts.timerCurrentRemaining > Duration.zero;
                  // Show Resume if timer has time remaining and is not running
                  final shouldShowResume = hasRemaining && !isRunning;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            context,
                            label: shouldShowResume ? "Resume" : "Start",
                            onPressed: isRunning
                                ? null
                                : () {
                                    timeService.startTimer();
                                    SnackbarHelper.showSnackbar(
                                      context,
                                      shouldShowResume
                                          ? 'Timer resumed'
                                          : 'Timer started',
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
                        const SizedBox(width: 8),
                        Expanded(
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
        backgroundColor: Colors.transparent,
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
        const SizedBox(width: 10),
        _buildCustomButton(context, timeService),
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
    return OutlinedButton(
      onPressed: () => timeService.setTimerDuration(duration),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: themeService.getSecondaryTextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context, TimeService timeService) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    return OutlinedButton(
      onPressed: () => _showCustomDurationDialog(context, timeService),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        "Custom",
        style: themeService.getSecondaryTextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  void _showCustomDurationDialog(
    BuildContext context,
    TimeService timeService,
  ) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    final hoursController = TextEditingController(text: "0");
    final minutesController = TextEditingController(text: "0");
    final secondsController = TextEditingController(text: "0");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeService.backgroundColor,
        title: Text(
          "Set Custom Duration",
          style: themeService.getSecondaryTextStyle(
            color: themeService.primaryColor,
            fontSize: 20,
          ),
        ),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                controller: hoursController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                ),
                decoration: InputDecoration(
                  labelText: "Hours",
                  labelStyle: themeService.getSecondaryTextStyle(
                    color: themeService.primaryColor.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: minutesController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                ),
                decoration: InputDecoration(
                  labelText: "Minutes",
                  labelStyle: themeService.getSecondaryTextStyle(
                    color: themeService.primaryColor.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: secondsController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: themeService.getSecondaryTextStyle(
                  color: themeService.primaryColor,
                ),
                decoration: InputDecoration(
                  labelText: "Seconds",
                  labelStyle: themeService.getSecondaryTextStyle(
                    color: themeService.primaryColor.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: themeService.primaryColor, width: 2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Cancel",
              style: themeService.getSecondaryTextStyle(
                color: themeService.primaryColor,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              final hours = int.tryParse(hoursController.text) ?? 0;
              final minutes = int.tryParse(minutesController.text) ?? 0;
              final seconds = int.tryParse(secondsController.text) ?? 0;

              final duration = Duration(
                hours: hours,
                minutes: minutes,
                seconds: seconds,
              );

              if (duration > Duration.zero) {
                timeService.setTimerDuration(duration);
                Navigator.pop(context);
                SnackbarHelper.showSnackbar(
                  context,
                  'Timer duration set to ${two(hours)}:${two(minutes)}:${two(seconds)}',
                  themeService,
                );
              }
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: themeService.primaryColor, width: 2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Set",
              style: themeService.getSecondaryTextStyle(
                color: themeService.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
