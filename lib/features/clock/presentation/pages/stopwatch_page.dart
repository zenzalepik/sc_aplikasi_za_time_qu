import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/time_service.dart';

class StopwatchPage extends StatelessWidget {
  const StopwatchPage({super.key});

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
                "Stopwatch",
                style: GoogleFonts.ptSans(
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
                selector: (_, service) => service.stopwatchRunning,
                builder: (context, isRunning, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(
                        context,
                        label: "Start",
                        onPressed: isRunning
                            ? null
                            : timeService.startStopwatch,
                      ),
                      const SizedBox(width: 20),
                      _buildButton(
                        context,
                        label: "Stop",
                        onPressed: isRunning ? timeService.stopStopwatch : null,
                      ),
                      const SizedBox(width: 20),
                      _buildButton(
                        context,
                        label: "Reset",
                        onPressed: timeService.resetStopwatch,
                      ),
                    ],
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
}
