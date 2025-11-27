import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/time_service.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  String two(int n) => n.toString().padLeft(2, "0");

  @override
  Widget build(BuildContext context) {
    final timeService = Provider.of<TimeService>(context);
    final duration = timeService.timerCurrentRemaining;
    final timerText =
        "${two(duration.inMinutes)}:${two(duration.inSeconds % 60)}";

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Timer",
                style: GoogleFonts.ptSans(
                  color: Colors.greenAccent,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                timerText,
                style: GoogleFonts.ptSans(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(
                    label: "Start",
                    onPressed: timeService.timerRunning
                        ? null
                        : timeService.startTimer,
                  ),
                  const SizedBox(width: 20),
                  _buildButton(
                    label: "Pause",
                    onPressed: timeService.timerRunning
                        ? timeService.stopTimer
                        : null,
                  ),
                  const SizedBox(width: 20),
                  _buildButton(
                    label: "Reset",
                    onPressed: timeService.resetTimer,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              if (!timeService.timerRunning)
                _buildDurationPicker(context, timeService),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required String label, VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
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
      child: Text(label, style: GoogleFonts.ptSans(color: Colors.greenAccent)),
    );
  }
}
