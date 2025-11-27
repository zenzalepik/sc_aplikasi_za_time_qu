import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/time_service.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  String two(int n) => n.toString().padLeft(2, "0");

  @override
  Widget build(BuildContext context) {
    // Access TimeService without listening
    final timeService = Provider.of<TimeService>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Timer",
                style: GoogleFonts.ptSans(
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
                    style: GoogleFonts.ptSans(
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
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(
                        context,
                        label: "Start",
                        onPressed: isRunning ? null : timeService.startTimer,
                      ),
                      const SizedBox(width: 20),
                      _buildButton(
                        context,
                        label: "Pause",
                        onPressed: isRunning ? timeService.stopTimer : null,
                      ),
                      const SizedBox(width: 20),
                      _buildButton(
                        context,
                        label: "Reset",
                        onPressed: timeService.resetTimer,
                      ),
                    ],
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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[900],
        foregroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label, style: GoogleFonts.ptSans(fontSize: 18)),
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
    return TextButton(
      onPressed: () => timeService.setTimerDuration(duration),
      child: Text(
        label,
        style: GoogleFonts.ptSans(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
