import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/time_service.dart';

class StopwatchPage extends StatelessWidget {
  const StopwatchPage({super.key});

  String two(int n) => n.toString().padLeft(2, "0");

  @override
  Widget build(BuildContext context) {
    final timeService = Provider.of<TimeService>(context);
    final sw = timeService.stopwatchElapsed;
    final swText =
        "${two(sw.inMinutes)}:${two(sw.inSeconds % 60)}:${two((sw.inMilliseconds ~/ 10) % 100)}";

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Stopwatch",
                style: GoogleFonts.ptSans(
                  color: Colors.greenAccent,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                swText,
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
                    onPressed: timeService.stopwatchRunning
                        ? null
                        : timeService.startStopwatch,
                  ),
                  const SizedBox(width: 20),
                  _buildButton(
                    label: "Stop",
                    onPressed: timeService.stopwatchRunning
                        ? timeService.stopStopwatch
                        : null,
                  ),
                  const SizedBox(width: 20),
                  _buildButton(
                    label: "Reset",
                    onPressed: timeService.resetStopwatch,
                  ),
                ],
              ),
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
}
